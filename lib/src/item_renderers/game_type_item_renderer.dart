part of rps;

class GameTypeItemRenderer<String> extends ItemRenderer {
  
  RichText label;
  
  GameTypeItemRenderer({String elementId: null}) : super(elementId: null, autoDrawBackground: false) {
    className = 'GameTypeItemRenderer';
  }

  static GameTypeItemRenderer construct() => new GameTypeItemRenderer()..layout = new HorizontalLayout()..gap = 0;
  
  @override
  void createChildren() {
    super.createChildren();
    
    label = new RichText()
    ..percentWidth = 100.0
    ..height = 22;
    
    addComponent(label);
  }
  
  @override
  void invalidateData() {
    if (label != null) label.text = data;
  }
}