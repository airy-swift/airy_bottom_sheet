import 'package:airy_bottom_sheet/src/controller/airy_bottom_sheet_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  AiryBottomSheetController? controller;

  const initialHeight = 100.0;
  const magnetPoints = <List<double>>[
    [100],
    [200, 300],
    [400, 500],
  ];
  final flatten = magnetPoints.expand((v) => v);
  const maxGap = 20.0;
  final maxHeight = flatten.last + maxGap;
  const minGap = 20.0;
  final minHeight = flatten.first - minGap;

  setUp(() {
    controller = AiryBottomSheetController(
      initialHeight: initialHeight,
      magnetPoints: magnetPoints,
      maxHeight: maxHeight,
      minHeight: minHeight,
    );
  });

  test('test [AiryBottomSheetController.height]', () {
    final target = controller!;

    /// 1. no touch
    /// 2. correct [minHeight]
    /// 3. correct [maxHeight]

    // 1
    expect(target.height, initialHeight);
    // 2
    target.height = minHeight - 10;
    expect(target.height, minHeight);
    // 3
    target.height = maxHeight + 10;
    expect(target.height, maxHeight);
  });

  group('test [AiryBottomSheetController.magnetPoints]', () {
    /// 1. no touch
    /// 2. update [AiryBottomSheetController.magnetPoints] and [AiryBottomSheetController.height]
    /// 3. update [AiryBottomSheetController.magnetPoints] and correct [AiryBottomSheetController.height] to [minHeight]
    /// 4. update [AiryBottomSheetController.magnetPoints] and correct [AiryBottomSheetController.height] to [maxHeight]

    test('test 1: no touch', () {
      final target = controller!;
      expect(target.value.magnetPoints, magnetPoints);
      expect(target.value.height, initialHeight);
    });
    test('test 2: update [AiryBottomSheetController.magnetPoints] and [AiryBottomSheetController.height]', () {
      final target = controller!;
      const testHeight = 200.0;
      const testValue = <List<double>>[
        [testHeight],
        [300],
      ];
      target.magnetPoints = testValue;
      expect(target.value.magnetPoints, testValue);
      expect(target.height, testHeight);
    });
    test('test 3: update [AiryBottomSheetController.magnetPoints] and correct [AiryBottomSheetController.height] to [minHeight]', () {
      final target = controller!;
      final testHeight = minHeight + 10;
      final testValue = <List<double>>[
        [testHeight],
        [300],
      ];
      expect(target.height, 100);
      target.magnetPoints = testValue;
      expect(target.value.magnetPoints, testValue);
      expect(target.height, testHeight);
    });
    test('test 4: update [AiryBottomSheetController.magnetPoints] and correct [AiryBottomSheetController.height] to [maxHeight]', () {
      final target = controller!;
      final testHeight = maxHeight - 10;
      final testValue = <List<double>>[
        [300, 400],
        [testHeight],
      ];
      target.height = 1000;
      expect(target.height, maxHeight);

      target.magnetPoints = testValue;
      expect(target.value.magnetPoints, testValue);
      expect(target.height, testHeight);
    });
  });

  test('test [AiryBottomSheetController drag properties]', () {
    final target = controller!;

    /// 1. not touch
    /// 2. assignment
    /// 3. clear

    // 1
    expect(target.dragStartHeightCache, null);
    expect(target.dragUpdateStartCache, null);
    expect(target.isDragging, false);
    // 2
    target.dragStartHeightCache = minHeight;
    target.dragUpdateStartCache = maxHeight;
    target.isDragging = true;
    expect(target.dragStartHeightCache, minHeight);
    expect(target.dragUpdateStartCache, maxHeight);
    expect(target.isDragging, true);
    // 3
    target.clearDragProperties();
    expect(target.dragStartHeightCache, null);
    expect(target.dragUpdateStartCache, null);
    expect(target.isDragging, false);
  });

  group('test [AiryBottomSheetController drag events]', () {
    /// 1. no touch
    /// 2. height < minHeight
    /// 3. minHeight < height < magnetPoints.min
    /// 4. height == magnetPoints.min
    /// 5. magnetPoints.min < height < (magnetPoints.min + (magnetPoints.min + 1)) / 2
    /// 6. (magnetPoints.min + (magnetPoints.min + 1)) / 2 < height < (magnetPoints.min + 1)
    /// 7. ((magnetPoints.min + 1) + (magnetPoints.min + 2)) / 2 < height < (magnetPoints.min + 2)
    /// 8. ((magnetPoints.max - 2) + (magnetPoints.max - 1)) / 2 < height < (magnetPoints.max - 1)
    /// 9. ((magnetPoints.max - 1) + magnetPoints.max) / 2 < height < magnetPoints.max
    /// 10. maxHeight < height
    /// 11. not started

    pattern(Map<double, double> moveAndExpect, double end) {
      final target = controller!;
      // start
      target.onDragStart(null);
      expect(target.dragStartHeightCache, initialHeight);
      expect(target.isDragging, true);
      // update
      for (final entry in moveAndExpect.entries) {
        target.onVerticalDragUpdate(DragUpdateDetails(globalPosition: Offset.zero, localPosition: Offset(0, entry.key)));
        expect(target.value.height, entry.value, reason: 'moved: ${target.dragStartHeightCache! - entry.key}, but the test expected: ${entry.value}');
      }
      // end
      target.onVerticalDragEnd(DragEndDetails(globalPosition: Offset.zero));
      expect(target.value.height, end);
      expect(target.dragStartHeightCache, null);
      expect(target.isDragging, false);
    }

    test('test 1: no touch', () {
      final target = controller!;
      expect(target.value.height, initialHeight);
    });
    test('test 2: height < minHeight', () {
      pattern(
        {
          minHeight: flatten.first,
          minHeight + minGap + 10: minHeight,
          minHeight + minGap + 20: minHeight,
        },
        flatten.first,
      );
    });
    test('test 3: minHeight < height < magnetPoints.min', () {
      pattern(
        {
          flatten.first: flatten.first,
          flatten.first + 10: flatten.first - 10,
          flatten.first + minGap: flatten.first - minGap,
        },
        flatten.first,
      );
    });
    test('test 4: height == magnetPoints.min', () {
      pattern(
        {
          flatten.first: flatten.first,
          flatten.first + 10: flatten.first - 10,
          flatten.first - 10: flatten.first + 10,
          flatten.first: flatten.first,
        },
        flatten.first,
      );
    });
    test('test 5: magnetPoints.min < height < (magnetPoints.min + (magnetPoints.min + 1)) / 2', () {
      pattern(
        {
          flatten.first: flatten.first,
          90: 110,
          80: 120,
          70: 130,
          60: 140,
          50: 150,
        },
        200,
      );
    });
    test('test 6: (magnetPoints.min + (magnetPoints.min + 1)) / 2 < height < (magnetPoints.min + 1)', () {
      pattern(
        {
          flatten.first: flatten.first,
          90: 110,
          80: 120,
          70: 130,
          60: 140,
          50: 150,
          49: 151,
        },
        200,
      );
    });
    test('test 7: ((magnetPoints.min + 1) + (magnetPoints.min + 2)) / 2 < height < (magnetPoints.min + 2)', () {
      pattern(
        {
          flatten.first: flatten.first,
          50: 150,
          0: 200,
          -10: 210,
          -20: 220,
          -30: 230,
          -40: 240,
          -50: 250,
          -51: 251,
        },
        300,
      );
    });
    test('test 8: ((magnetPoints.max - 2) + (magnetPoints.max - 1)) / 2 < height < (magnetPoints.max - 1)', () {
      pattern(
        {
          flatten.first: flatten.first,
          50: 150,
          0: 200,
          -50: 250,
          -150: 350,
          -151: 351,
        },
        400,
      );
    });
    test('test 9. ((magnetPoints.max - 1) + magnetPoints.max) / 2 < height < magnetPoints.max', () {
      pattern(
        {
          flatten.first: flatten.first,
          50: 150,
          0: 200,
          -50: 250,
          -300: 500,
          -310: 510,
        },
        500,
      );
    });
    test('test 10. maxHeight < height', () {
      pattern(
        {
          flatten.first: flatten.first,
          50: 150,
          0: 200,
          -300: 500,
          -400: maxHeight,
        },
        500,
      );
    });
    test('test 10. maxHeight < height', () {
      final target = controller!;
      // update
      target.onVerticalDragUpdate(DragUpdateDetails(globalPosition: Offset.zero, localPosition: const Offset(0, -500)));
      expect(target.value.height, initialHeight);
      target.onVerticalDragUpdate(DragUpdateDetails(globalPosition: Offset.zero, localPosition: const Offset(0, 500)));
      expect(target.value.height, initialHeight);
      target.onVerticalDragUpdate(DragUpdateDetails(globalPosition: Offset.zero, localPosition: const Offset(0, 100)));
      expect(target.value.height, initialHeight);
      expect(target.dragStartHeightCache, null);
      expect(target.isDragging, false);
      // end
      target.onVerticalDragEnd(DragEndDetails(globalPosition: Offset.zero));
      expect(target.value.height, initialHeight);
      expect(target.dragStartHeightCache, null);
      expect(target.isDragging, false);
    });
  });
}
