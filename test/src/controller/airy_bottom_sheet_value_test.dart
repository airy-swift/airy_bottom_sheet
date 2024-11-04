import 'package:airy_bottom_sheet/src/controller/airy_bottom_sheet_value.dart';
import 'package:airy_bottom_sheet/src/model/front_switch_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  AiryBottomSheetValue? airyBottomSheetValue;

  setUp(() {
    airyBottomSheetValue = AiryBottomSheetValue(
      height: 0,
      magnetPoints: [
        [100],
        [200, 300],
        [400, 500],
      ],
    );
  });

  group('test [AiryBottomSheetValue.findSwitchDataInNestedList]', () {
    /// 1. target < 100
    /// 2. 100 < target <= 200
    /// 3. 200 < target <= 300
    /// 4. 300 < target <= 400
    /// 5. 400 < target <= 500
    /// 6. 500 < target

    test('test 1: target <= 100', () {
      final value = airyBottomSheetValue!;
      expect(value.findSwitchDataInNestedList(80) == FrontSwitchData(0, 1, 0), true);
      expect(value.findSwitchDataInNestedList(100) == FrontSwitchData(0, 1, 0), true);
    });
    test('test 2: 100 < target <= 200', () {
      final value = airyBottomSheetValue!;
      expect(value.findSwitchDataInNestedList(110) == FrontSwitchData(0, 1, 0.1), true);
      expect(value.findSwitchDataInNestedList(140) == FrontSwitchData(0, 1, 0.4), true);
      expect(value.findSwitchDataInNestedList(149) == FrontSwitchData(0, 1, 0.49), true);
      expect(value.findSwitchDataInNestedList(150) == FrontSwitchData(1, 0, 0.5), true);
      expect(value.findSwitchDataInNestedList(151) == FrontSwitchData(1, 0, 0.51), true);
      expect(value.findSwitchDataInNestedList(160) == FrontSwitchData(1, 0, 0.6), true);
      expect(value.findSwitchDataInNestedList(199) == FrontSwitchData(1, 0, 0.99), true);
      expect(value.findSwitchDataInNestedList(200) == FrontSwitchData(1, 0, 1), true);
    });
    test('test 3: 200 < target <= 300', () {
      final value = airyBottomSheetValue!;
      expect(value.findSwitchDataInNestedList(201) == FrontSwitchData(1, 1, 1.0), true);
      expect(value.findSwitchDataInNestedList(249) == FrontSwitchData(1, 1, 1.0), true);
      expect(value.findSwitchDataInNestedList(250) == FrontSwitchData(1, 1, 1.0), true);
      expect(value.findSwitchDataInNestedList(251) == FrontSwitchData(1, 1, 1.0), true);
      expect(value.findSwitchDataInNestedList(299) == FrontSwitchData(1, 1, 1.0), true);
      expect(value.findSwitchDataInNestedList(300) == FrontSwitchData(1, 1, 1.0), true);
    });
    test('test 4: 300 < target <= 400', () {
      final value = airyBottomSheetValue!;
      expect(value.findSwitchDataInNestedList(301) == FrontSwitchData(1, 2, 0.01), true);
      expect(value.findSwitchDataInNestedList(349) == FrontSwitchData(1, 2, 0.49), true);
      expect(value.findSwitchDataInNestedList(350) == FrontSwitchData(2, 1, 0.5), true);
      expect(value.findSwitchDataInNestedList(351) == FrontSwitchData(2, 1, 0.51), true);
      expect(value.findSwitchDataInNestedList(399) == FrontSwitchData(2, 1, 0.99), true);
      expect(value.findSwitchDataInNestedList(400) == FrontSwitchData(2, 1, 1.0), true);
    });
    test('test 5: 400 < target <= 500', () {
      final value = airyBottomSheetValue!;
      expect(value.findSwitchDataInNestedList(401) == FrontSwitchData(2, 2, 1.0), true);
      expect(value.findSwitchDataInNestedList(449) == FrontSwitchData(2, 2, 1.0), true);
      expect(value.findSwitchDataInNestedList(450) == FrontSwitchData(2, 2, 1.0), true);
      expect(value.findSwitchDataInNestedList(451) == FrontSwitchData(2, 2, 1.0), true);
      expect(value.findSwitchDataInNestedList(499) == FrontSwitchData(2, 2, 1.0), true);
      expect(value.findSwitchDataInNestedList(500) == FrontSwitchData(2, 2, 1.0), true);
    });
    test('test 6: 500 < target', () {
      final value = airyBottomSheetValue!;
      expect(value.findSwitchDataInNestedList(501) == FrontSwitchData(2, 2, 1.0), true);
      expect(value.findSwitchDataInNestedList(600) == FrontSwitchData(2, 2, 1.0), true);
    });
  });
}
