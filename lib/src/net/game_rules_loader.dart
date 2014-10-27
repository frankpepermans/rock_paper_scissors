part of rps;

class GameRulesLoader extends Object with FrameworkEventDispatcherMixin implements IFrameworkEventDispatcher {
  
  final ObservableList<String> gameModeAssets = new ObservableList<String>.from(const <String>['assets/player_vs_cpu.png', 'assets/player_vs_player.png', 'assets/cpu_vs_cpu.png']);
  
  ObservableList<String> gameTypes = new ObservableList<String>();
  
  @observable GameRuleSet ruleset;
  
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
  
}