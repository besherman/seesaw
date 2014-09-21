library button_test;

import 'package:unittest/unittest.dart';

import "package:seesaw/seesaw.dart";

void main() {
    group("ButtonModel", () {
        ButtonModel model;
        List<ChangeEvent> events;
        
        setUp(() { 
            model = new ButtonModel();
            events = new List<ChangeEvent>();
            model.onStateChanged.listen((evt) => events.add(evt));
        });
        
        test("armed", () {
            // test that the default is correct
            expect(model.armed, isFalse);
            
            // test that armed works and that we get an event
            model.armed = true;
            expect(model.armed, isTrue);
            expect(events.length, equals(1));        
            model.armed = false;
            expect(model.armed, isFalse);
            expect(events.length, equals(2));        
        });
        
        test("enabled", () {
            // test that the default is correct
            expect(model.enabled, isTrue);        
            
            // test that enabled works and that we get an event
            model.enabled = false;
            expect(model.enabled, isFalse);
            expect(events.length, equals(1));        
            model.enabled = true;
            expect(model.enabled, isTrue);
            expect(events.length, equals(2));        
        });
        
        test("pressed", () {
            // test that the default is correct
            expect(model.pressed, isFalse);        
            
            // test that enabled works and that we get an event
            model.pressed = true;
            expect(model.pressed, isTrue);
            expect(events.length, equals(1));        
            model.pressed = false;
            expect(model.pressed, isFalse);
            expect(events.length, equals(2));        
        });
        
        test("rollover", () {
            // test that the default is correct
            expect(model.rollover, isFalse);        
            
            // test that enabled works and that we get an event
            model.rollover = true;
            expect(model.rollover, isTrue);
            expect(events.length, equals(1));        
            model.rollover = false;
            expect(model.rollover, isFalse);
            expect(events.length, equals(2));        
        });
        
        test("selected", () {
            // test that the default is correct
            expect(model.selected, isFalse);        
            
            // test that enabled works and that we get an event
            model.selected = true;
            expect(model.selected, isTrue);
            expect(events.length, equals(1));        
            model.selected = false;
            expect(model.selected, isFalse);
            expect(events.length, equals(2));        
        });
    });

}