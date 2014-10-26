import 'dart:html';
import 'package:rock_paper_scissors/src/rock_paper_scissors.dart';

void main() {
  Controller view = new Controller()
  ..wrapTarget(querySelector('#dart_flex_container'))
  ..percentWidth = 100.0
  ..percentHeight = 100.0;
  
  view.switchToScreen('titleScreen');
}