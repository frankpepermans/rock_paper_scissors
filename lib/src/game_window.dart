part of rps;

class GameWindow extends SkinnableComponent {
  
  @observable GameRulesLoader rulesLoader;
  
  RichText countdownLabel;
  
  @observable String countdownText;
  
  @Skin('rock_paper_scissors|lib/src/skins/game_window.xml')
  GameWindow() : super();
  
  void reset() {
    int S = 5;
    
    countdownText = 'Game starts in $S';
    
    new Timer.periodic(const Duration(seconds: 1), (Timer T) {
      if (S > 1) {
        S--;
        
        countdownText = 'Game starts in $S';
      } else {
        T.cancel();
        
        switchToScreen('selectionScreen');
      }
    });
    
    switchToScreen('timerScreen');
  }
  
  @override
  void partAdded(IUIWrapper part) {
  }
  
  void switchToScreen(String screenName) {
    List<SkinState> states = new List<SkinState>(1);
    
    switch (screenName) {
      case 'timerScreen': states[0] = const SkinState('timerScreen'); break;
      case 'selectionScreen': states[0] = const SkinState('selectionScreen'); break;
      case 'resultsScreen': states[0] = const SkinState('resultsScreen'); break;
    }
    
    currentSkinStates = states;
  }
}