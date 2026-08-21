import 'package:flutter_test/flutter_test.dart';
import 'package:grozzby/core/theme/app_theme.dart';

void main() {
  test('App theme loads', () {
    expect(AppTheme.light.scaffoldBackgroundColor, isNotNull);
  });
}
