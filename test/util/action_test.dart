library action_test;

import 'package:unittest/unittest.dart';

import "package:seesaw/seesaw.dart";

void main() {
        
    test("ctor", () {
        var name = "name",
            enabled = false,
            icon = new ImageIcon("not-found"),
            f = (e) {};
            
        var action = new Action(name: name, icon: icon, enabled: enabled, action: f);
        expect(action.name, equals(name));
        expect(action.icon, equals(icon));
        expect(action.enabled, equals(enabled));
        expect(action.actionPerformed, equals(f));
    });
    
    test("properties", () {
        var action = new Action();
        
        expect(action.name, equals(""));
        action.name = "test-name";
        expect(action.name, equals("test-name"));
        
        expect(action.enabled, isTrue);
        action.enabled = false;
        expect(action.enabled, isFalse);
        
        expect(action.icon, isNull);
        var icon = new ImageIcon("not-found");
        action.icon = icon;
        expect(action.icon, same(icon));
        
        var f = (e) {};
        action.actionPerformed = f;
        expect(action.actionPerformed, same(f));
    });
    
    group("onPropertyChange", () {
        test("name", () {
            var action = new Action();
            action.onPropertyChange.listen(expectAsync((e) {
                var evt = e as PropertyChangeEvent;
                expect(evt.propertyName, equals("name"));
                expect(evt.oldValue, equals(""));
                expect(evt.newValue, equals("foobar"));
            }));

            action.name = "foobar";
        });
        
        test("enabled", () {
            var action = new Action();
            action.onPropertyChange.listen(expectAsync((e) {
                var evt = e as PropertyChangeEvent;
                expect(evt.propertyName, equals("enabled"));
                expect(evt.oldValue, equals(true));
                expect(evt.newValue, equals(false));
            }));

            action.enabled = false;
        });
        
        test("icon", () {
            var expectedProperty = "icon",
                expectedOldValue = null,
                expectedNewValue = new ImageIcon("not-found");                
            
            var action = new Action();
            action.onPropertyChange.listen(expectAsync((e) {
                var evt = e as PropertyChangeEvent;
                expect(evt.propertyName, equals(expectedProperty));
                expect(evt.oldValue, equals(expectedOldValue));
                expect(evt.newValue, equals(expectedNewValue));
            }));

            action.icon = expectedNewValue;
        });
    });
}
