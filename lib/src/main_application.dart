part of rps;

class MainApplication extends SkinnableComponent {
  
  Group titleWindow, setupWindow;
  GameWindow gameWindow;
  
  @Skin('rock_paper_scissors|lib/src/skins/main_page.xml')
  MainApplication() : super();
  
  @override
  void partAdded(IUIWrapper part) {
    if (part == titleWindow) {
      new Timer(const Duration(seconds: 3), () => switchToScreen('setupScreen'));
    }
  }
  
  void setGameType(String gameType, GameRulesLoader loader) {
    loader.setupGameType(gameType);
  }
  
  void setPlayers(String playerMode, GameRulesLoader loader) {
    loader.setupPlayers(playerMode);
  }
  
  void startGame() {
    switchToScreen('gameScreen');
    
    gameWindow.reset();
  }
  
  void switchToScreen(String screenName) {
    List<SkinState> states = new List<SkinState>(1);
    
    switch (screenName) {
      case 'titleScreen': states[0] = const SkinState('titleScreen'); break;
      case 'setupScreen': states[0] = const SkinState('setupScreen'); break;
      case 'gameScreen': states[0] = const SkinState('gameScreen'); break;
    }
    
    currentSkinStates = states;
  }
}