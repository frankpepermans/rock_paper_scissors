part of rps;

class GameRulesLoader extends Object with FrameworkEventDispatcherMixin implements IFrameworkEventDispatcher {
  
  ObservableList<String> gameModeAssets = new ObservableList<String>.from(const <String>['assets/player_vs_cpu.png', 'assets/player_vs_player.png', 'assets/cpu_vs_cpu.png']);
  ObservableList<String> gameTypes = new ObservableList<String>();
  Map<String, ObservableList<String>> gameChoices = <String, ObservableList<String>>{};
  
  @observable ObservableList<String> choices = new ObservableList<String>();
  
  //---------------------------------
  // source
  //---------------------------------
  
  final String source;
  
  GameRulesLoader(this.source) {
    HttpRequest.request(source, method: 'GET', responseType: 'text').then(
      (HttpRequest R) => _parseJSON(JSON.decode(R.responseText))    
    );
  }
  
  void _parseJSON(List<Map<String, dynamic>> jsonData) {
    jsonData.forEach(
      (Map<String, dynamic> gameType) {
        gameTypes.add(gameType['name']);
        
        gameChoices[gameType['name']] = new ObservableList<String>();
        
        gameType['assets'].forEach(
          (Map<String, String> A) => gameChoices[gameType['name']].add(A['asset'])   
        );
      }
    );
  }
}