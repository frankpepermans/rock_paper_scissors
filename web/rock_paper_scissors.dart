import 'dart:html';
import 'dart:async';
import 'package:rock_paper_scissors/src/rock_paper_scissors.dart';
import 'package:dart_flex/dart_flex.dart';
import 'package:observe/observe.dart';

void main() {
  SkinnableComponent view = new SkinnableComponent()
      ..wrapTarget(querySelector('#dart_flex_container'))
      ..percentWidth = 100.0
      ..percentHeight = 100.0;
}

class BaseClass extends VGroup {
  
  BaseClass() : super() {}
  
}

class SkinnableComponent extends BaseClass {
  
  @Skin('rock_paper_scissors|lib/src/skins/main_page.xml')
  SkinnableComponent() : super();
}
