import "dart:html";
import "package:unittest/unittest.dart";

import "package:seesaw/seesaw.dart";

void ready() {
  print("i am ready baby!");
}

void runMyTests() {
    
}


void main() {
  runMyTests();
  
  var canvas = querySelector("#canvas") as CanvasElement;
  
//  canvas.width = window.innerWidth;
//  canvas.height = window.innerHeight;
//  
//  var ctx = canvas.getContext("2d") as CanvasRenderingContext2D;
//  
//  ctx.translate(100,  100);
//  
//  ctx.rect(0, 0, 10, 10);
//  ctx.clip();
//  
//  ctx.fillRect(0, 0, 640, 480);
//  
//  ctx.beginPath();
//  ctx.rect(0,  0,  100, 100);  
//  ctx.clip();
//  
//  ctx.fillRect(0, 0, 640, 480);
  
  
  
  var frame = new Frame(canvas);
  var panel = new Component();
  panel.name = "panel with dialog border";
  panel.bounds = new Rectangle<int>(200, 100, 640, 480);
  panel.background = "white";
  panel.border = new DialogBorder();
  
  var label = new Component();
  label.name = "small rectangle in the middle";
  label.bounds = new Rectangle<int>(315, 235, 100, 100);
  label.border = new LineBorder(1, "black");
  
  //label.onMouseMoved.listen((e) => print("listener got event: " + e.toString()));
  //label.onMousePressed.listen((e) => print("got pressed"));
  //label.onMouseReleased.listen((e) => print("got released"));
  //label.onMouseClicked.listen((e) => print("got clicked"));
  //label.onMouseDragged.listen((e) => print("got dragged"));
  //label.onMouseEntered.listen((e) => print("entered"));
  //label.onMouseExited.listen((e) => print("exited"));
   
  
  panel.add(label);
  
  var button = new Button();
  //button.background = "white";
  button.bounds = new Rectangle<int>(20, 50, 100, 25);
  button.text = "Click me";
  button.border = new LineBorder(1, "black");
  
  panel.add(button);
  
  frame.add(panel);
  frame.validate();
  frame.repaint();
   

  
  
}

