import "dart:html" as html;
import "package:unittest/unittest.dart";
import "dart:math";

import "package:seesaw/seesaw.dart";




void main() {
  
  var canvas = html.querySelector("#canvas") as html.CanvasElement;
  
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
  panel.background = Color.WHITE;
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
  
  var action = new Action(name: "GO!", icon: new ImageIcon("img/16_address_book.png", 16, 16), action: (e) {
      print("he's telling me to go!");
  });
  
  var button = new Button(action: action);
  //button.background = "white";
  button.bounds = new Rectangle<int>(20, 50, 100, 25);
//  button.text = "Click me";
//  //button.onActionPerformed.listen((e) => print("clicked!"));
//  button.icon = new ImageIcon("img/16_address_book.png", 16, 16);
//  
  panel.add(button);
  
  TextField textField = new TextField("Hello, world!");
  textField.bounds = new Rectangle<int>(20, 100, 100, 20);
  panel.add(textField);
  
  frame.add(panel);
  frame.validate();
  frame.repaint();
   

  
  
}

