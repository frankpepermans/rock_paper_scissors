part of rps;

enum GameMode {
  player_vs_cpu,
  player_vs_player,
  cpu_vs_cpu
}

class GameRulesLoader extends Object with FrameworkEventDispatcherMixin implements IFrameworkEventDispatcher {
  final ObservableList<GameMode> gameModeAssets = new ObservableList<GameMode>.from(GameMode.values);
  ObservableList<String> gameTypes = new ObservableList<String>();
  
  @observable GameRuleSet ruleset;
  @observable GameMode playerMode;
  
  List<Map<String, dynamic>> _raw;
  
  //---------------------------------
  // source
  //---------------------------------
  
  final String source;
  
  GameRulesLoader(this.source) {
    HttpRequest.request(source, method: 'GET', responseType: 'text').then(
      (HttpRequest R) {
        _raw = JSON.decode(R.responseText);
        
        extractGameTypes();
      }
    );
  }
  
  void extractGameTypes() {
    _raw.forEach(
      (Map<String, dynamic> gameType) => gameTypes.add(gameType['name'])
    );
  }
  
  void setupGameType(String T) {
    final Map<String, dynamic> R = _raw.firstWhere(
      (Map<String, dynamic> gameType) => (gameType['name'] == T),
      orElse: () => null
    );
    
    if (R == null) throw new ArgumentError('requested game type $T does not exist!');
    
    ruleset = new GameRuleSet(R);
  }
  
  void setupPlayers(GameMode P) {
    playerMode = P;
  }
}

class MatchUpResult {
  
  final String winner, loser, relation;
  final int result;
  
  const MatchUpResult(this.winner, this.loser, this.result, this.relation);
  
  factory MatchUpResult.TIE() => const MatchUpResult(null, null, 0, 'tie');
  
}

class GameRuleSet extends Observable {
  
  final Map<String, dynamic> rawData;
  
  @observable String theme, name;
  @observable ObservableList<Map<String, String>> assets;
  @observable ObservableList<List<int>> matrix;
  @observable ObservableList<List<String>> relations;
  
  GameRuleSet(this.rawData) {
    theme = rawData['theme'];
    name = rawData['name'];
    assets = new ObservableList<Map<String, String>>.from(rawData['assets']);
    matrix = new ObservableList<List<int>>.from(rawData['matrix']);
    relations = new ObservableList<List<String>>.from(rawData['relations']);
  }
  
  MatchUpResult matchUp(String left, String right) {
    if (left == right) return new MatchUpResult.TIE();
    
    final int assetsLen = assets.length;
    int li = -1, ri = -1;
    
    for (int i=0; i<assetsLen; i++) {
      if (assets[i]['name'] == left)  li = i;
      if (assets[i]['name'] == right) ri = i;
      
      if (li != -1 && ri != -1) break;
    }
    
    if (li == -1 && ri >= 0) return new MatchUpResult(right, left, -1, 'left side failed to choose in time!');
    if (ri == -1 && li >= 0) return new MatchUpResult(left, right, 1, 'right side failed to choose in time!');
    
    final int res = matrix[li][ri];
    
    if (res == 0) return new MatchUpResult.TIE();
    else if (res == 1) return new MatchUpResult(left, right, res, relations[li][ri]);
    else if (res == -1) return new MatchUpResult(right, left, res, relations[ri][li]);
    
    return null;
  }
}