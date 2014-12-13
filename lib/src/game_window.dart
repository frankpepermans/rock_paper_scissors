part of rps;

class GameWindow extends SkinnableComponent {
  
  @observable GameRulesLoader rulesLoader;
  
  ListRenderer playerOneSelectionGroup, playerTwoSelectionGroup;
  String playerOneSelection, playerTwoSelection;
  int playerOneScore = 0, playerTwoScore = 0;
  RichText countdownLabel, resultLabel;
  Group selectionTimer;
  
  @observable String countdownText, resultText;
  
  @Skin('rock_paper_scissors|lib/src/skins/game_window.xml')
  GameWindow() : super();
  
  void beginCountdown() {
    int S = 5;
    
    countdownText = 'Game starts in $S';
    
    new Timer.periodic(const Duration(seconds: 1), (Timer T) {
      if (S > 1) countdownText = 'Game starts in ${--S}';
      else {
        T.cancel();
        
        play();
      }
    });
    
    switchToScreen('timerScreen');
  }
  
  void play() {
    final Random R = new Random();
    int cssVal = 0;
    
    switchToScreen('selectionScreen');
    
    new Timer.periodic(const Duration(milliseconds: 20), (Timer T) {
      if (cssVal > -400) {
        reflowManager.invalidateCSS(selectionTimer.control, 'background-position', '${--cssVal}px');
        
        if (cssVal % 10 == 0) {
          switch (rulesLoader.playerMode) {
            case GameMode.player_vs_cpu : 
              playerTwoSelectionGroup.selectedIndex = R.nextInt(rulesLoader.gameModeAssets.length); break;
            case GameMode.cpu_vs_cpu : 
              playerOneSelectionGroup.selectedIndex = R.nextInt(rulesLoader.gameModeAssets.length);
              playerTwoSelectionGroup.selectedIndex = R.nextInt(rulesLoader.gameModeAssets.length); break;
            default: break;
          }
        }
      }
      else {
        T.cancel();
        
        end();
      }
    });
  }
  
  void end() {
    final MatchUpResult R = rulesLoader.ruleset.matchUp(playerOneSelection, playerTwoSelection);
    final String leftRes = (R.result == -1) ? playerTwoSelection : playerOneSelection;
    final String rightRes = (R.result == -1) ? playerOneSelection : playerTwoSelection;
    final String winner = (R.result == 0) ? 'TIED' : (R.result == 1) ? 'PLAYER ONE WINS !!!' : 'PLAYER TWO WINS !!!';
    
    switchToScreen('resultsScreen');
    
    if (leftRes == null || rightRes == null || R.result == 0) resultText = '${R.relation}<br>$winner';
    else resultText = '$leftRes ${R.relation} $rightRes<br>$winner';
    
    playerOneScore += (R.result == 1) ? 1 : 0;
    playerTwoScore += (R.result == -1) ? 1 : 0;
    
    new Timer(const Duration(seconds: 5), () => beginCountdown());
  }
  
  @override
  void partAdded(IUIWrapper part) {
    if (part == playerOneSelectionGroup) {
      playerOneSelectionGroup.onSelectedItemChanged.listen(
        (FrameworkEvent<Map<String, String>> event) => playerOneSelection = event.relatedObject['name']
      );
    } else if (part == playerTwoSelectionGroup) {
      playerTwoSelectionGroup.onSelectedItemChanged.listen(
        (FrameworkEvent<Map<String, String>> event) => playerTwoSelection = event.relatedObject['name']
      );
    }
  }
  
  void switchToScreen(String screenName) {
    List<SkinState> states = new List<SkinState>(1);
    
    switch (screenName) {
      case 'timerScreen':     states[0]   =   const SkinState('timerScreen');       break;
      case 'selectionScreen': states[0]   =   const SkinState('selectionScreen');   break;
      case 'resultsScreen':   states[0]   =   const SkinState('resultsScreen');     break;
    }
    
    currentSkinStates = states;
  }
}