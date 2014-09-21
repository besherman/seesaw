library font_test;

import 'package:unittest/unittest.dart';

import "package:seesaw/seesaw.dart";

void main() {
    group("Font", () {
        
        setUp(() { 
        });
        
        test("factory ctor", () {
            // make sure that the factory constructor returns the
            // same instance if the parameters are the same
            var a = new Font("Tahoma", Font.PLAIN, 10),
                b = new Font("Tahoma", Font.PLAIN, 10),
                c = new Font("Tahoma", Font.PLAIN, 11);
            expect(identical(a, b), isTrue);
            expect(identical(a, c), isFalse);
        });
        
        test("toString()", () {
            // just test a bunch of them
            for(int i = 0; i < 100; i++) {
                Font font = new Font("font${i}", Font.PLAIN, i);                
                expect(font.toString(), equals("${i}pt font${i}"));
            }
            
            expect(new Font("Tahoma", Font.BOLD, 10).toString(), equals("bold 10pt Tahoma"));
            expect(new Font("Tahoma", Font.ITALIC, 10).toString(), equals("italic 10pt Tahoma"));
            expect(new Font("Tahoma", Font.BOLD | Font.ITALIC, 10).toString(), equals("italic bold 10pt Tahoma"));
        });
    });
}
