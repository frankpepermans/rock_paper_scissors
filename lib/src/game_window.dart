part of rps;

class GameWindow extends SkinnableComponent {
  
  @observable GameRulesLoader rulesLoader;
  
  @Skin('rock_paper_scissors|lib/src/skins/game_window.xml')
  GameWindow() : super();
  
  @override
  void partAdded(IUIWrapper part) {
  }
}