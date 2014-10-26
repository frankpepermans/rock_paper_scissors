part of rps;

class Controller extends SkinnableComponent {
  
  Group titleWindow, setupWindow, gameWindow;
  String selectedGameType;
  
  @Skin('rock_paper_scissors|lib/src/skins/main_page.xml')
  Controller() : super();
  
  @override
  void partAdded(IUIWrapper part) {
    if (part == titleWindow) {
      new Timer(const Duration(seconds: 3), () => switchToScreen('setupScreen'));
    }
  }
  
  void setGameType(String gameType, GameRulesLoader loader) {
    selectedGameType = gameType;
    
    loader.choices = loader.gameChoices[gameType];
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