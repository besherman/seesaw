import "package:unittest/unittest.dart";
import "package:unittest/html_enhanced_config.dart";

import "button/button_model_test.dart" as button_test;
import "util/font_test.dart" as font_test;

void main() {
    useHtmlEnhancedConfiguration();
    
    group("button tests", button_test.main);
    group("font tests", font_test.main);
}