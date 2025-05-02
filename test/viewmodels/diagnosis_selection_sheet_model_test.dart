import 'package:flutter_test/flutter_test.dart';
import 'package:health_managment_system/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('DiagnosisSelectionSheetModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
