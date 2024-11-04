import 'package:airy_bottom_sheet/src/controller/airy_bottom_sheet_controller.dart';
import 'package:airy_bottom_sheet/src/ui/airy_bottom_sheet.dart';
import 'package:airy_bottom_sheet/src/ui/handle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final _scaffoldKey = GlobalKey<ScaffoldState>();

Widget _createTestScreen({
  required AiryBottomSheetController controller,
}) =>
    MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          key: floatingButtonKey,
          onPressed: () {
            AiryBottomSheet.show(
              _scaffoldKey,
              controller: controller,
              switchChildren: [
                _firstChild(controller),
                _secondChild(controller),
                _thirdChild(controller),
              ],
            );
          },
        ),
      ),
    );

Widget _firstChild(AiryBottomSheetController controller) {
  return Column(
    children: [
      Handle(
        key: firstHandleKey,
        controller: controller,
        child: Container(
          color: Colors.redAccent,
          height: 1,
          child: const Text('first child'),
        ),
      ),
      Expanded(
        key: firstNotHandleKey,
        child: Container(
          color: Colors.black,
        ),
      )
    ],
  );
}

Widget _secondChild(AiryBottomSheetController controller) {
  return Handle(
    key: secondHandleKey,
    controller: controller,
    child: Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.red,
            child: const Text('second child'),
          ),
        ),
      ],
    ),
  );
}

Widget _thirdChild(AiryBottomSheetController controller) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Handle(
        key: thirdHandleKey,
        controller: controller,
        child: Container(
          color: Colors.redAccent,
          height: 1,
          child: const Text('third child'),
        ),
      ),
      Expanded(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(index.toString()),
            );
          },
        ),
      ),
    ],
  );
}

/// ------------------------------------------------------------
/// ------------------------------------------------------------
/// widget test
/// ------------------------------------------------------------
/// ------------------------------------------------------------

final floatingButtonKey = UniqueKey();
final firstHandleKey = UniqueKey();
final firstNotHandleKey = UniqueKey();
final secondHandleKey = UniqueKey();
final thirdHandleKey = UniqueKey();

extension WidgetTesterEx on WidgetTester {
  Future<void> offsetDrag(FinderBase<Element> finder, {required double dy}) async {
    return drag(finder, Offset(0, dy + (dy.isNegative ? -1 : 1)), touchSlopY: 1);
  }
}

void main() {
  Widget? targetWidget;
  AiryBottomSheetController? controller;

  setUp(() {
    controller = AiryBottomSheetController(
      initialHeight: 100,
      magnetPoints: [
        [100],
        [200, 300],
        [400, 500],
      ],
      maxHeight: 530,
      minHeight: 80,
    );
    targetWidget = _createTestScreen(controller: controller!);
  });

  group('Home Page Widget Tests', () {
    testWidgets('Testing Scrolling', (tester) async {
      await tester.pumpWidget(targetWidget!);
      await tester.tap(find.byKey(floatingButtonKey));
      await tester.pumpAndSettle();

      expect(find.text('first child'), findsOneWidget);

      // no effect
      await tester.offsetDrag(find.byKey(firstNotHandleKey), dy: 1000);
      await tester.pumpAndSettle();
      expect(controller!.height, 100);
      expect(find.text('first child'), findsOneWidget);
      await tester.offsetDrag(find.byKey(firstNotHandleKey), dy: -1000);
      await tester.pumpAndSettle();
      expect(controller!.height, 100);
      expect(find.text('first child'), findsOneWidget);

      // under _firstChild
      await tester.offsetDrag(find.byKey(firstHandleKey), dy: 100);
      await tester.pumpAndSettle();
      expect(controller!.height, 100);
      expect(find.text('first child'), findsOneWidget);
      await tester.offsetDrag(find.byKey(firstHandleKey), dy: 20);
      await tester.pumpAndSettle();
      expect(controller!.height, 100);
      expect(find.text('first child'), findsOneWidget);
      expect(find.text('second child'), findsOneWidget);
      expect(find.text('third child'), findsNothing);

      // back to _firstChild
      await tester.offsetDrag(find.byKey(firstHandleKey), dy: -1);
      await tester.pumpAndSettle();
      expect(controller!.height, 100);
      expect(find.text('first child'), findsOneWidget);
      await tester.offsetDrag(find.byKey(firstHandleKey), dy: -49);
      await tester.pumpAndSettle();
      expect(controller!.height, 100);
      expect(find.text('first child'), findsOneWidget);
      expect(find.text('second child'), findsOneWidget);
      expect(find.text('third child'), findsNothing);

      // proceed to _secondChild
      await tester.offsetDrag(find.byKey(firstHandleKey), dy: -50);
      await tester.pumpAndSettle();
      expect(controller!.height, 200);
      expect(find.text('second child'), findsOneWidget);
      await tester.offsetDrag(find.byKey(secondHandleKey), dy: 50);
      await tester.pumpAndSettle();
      expect(controller!.height, 200);
      expect(find.text('second child'), findsOneWidget);
      await tester.offsetDrag(find.byKey(secondHandleKey), dy: 51);
      await tester.pumpAndSettle();
      expect(controller!.height, 100);
      expect(find.text('first child'), findsOneWidget);
      await tester.offsetDrag(find.byKey(firstHandleKey), dy: -149);
      await tester.pumpAndSettle();
      expect(controller!.height, 200);
      expect(find.text('first child'), findsOneWidget);
      expect(find.text('second child'), findsOneWidget);
      expect(find.text('third child'), findsNothing);

      // between _secondChild(200) and _secondChild(300)
      await tester.offsetDrag(find.byKey(secondHandleKey), dy: -50);
      await tester.pumpAndSettle();
      expect(controller!.height, 300);
      expect(find.text('second child'), findsOneWidget);
      await tester.offsetDrag(find.byKey(secondHandleKey), dy: 50);
      await tester.pumpAndSettle();
      expect(controller!.height, 300);
      expect(find.text('second child'), findsOneWidget);
      await tester.offsetDrag(find.byKey(secondHandleKey), dy: 51);
      await tester.pumpAndSettle();
      expect(controller!.height, 200);
      expect(find.text('second child'), findsOneWidget);
      await tester.offsetDrag(find.byKey(secondHandleKey), dy: -149);
      await tester.pumpAndSettle();
      expect(controller!.height, 300);
      expect(find.text('first child'), findsNothing);
      expect(find.text('second child'), findsOneWidget);
      expect(find.text('third child'), findsNothing);

      // proceed to _thirdChild
      await tester.offsetDrag(find.byKey(secondHandleKey), dy: -50);
      await tester.pumpAndSettle();
      expect(controller!.height, 400);
      expect(find.text('third child'), findsOneWidget);
      await tester.offsetDrag(find.byKey(thirdHandleKey), dy: 50);
      await tester.pumpAndSettle();
      expect(controller!.height, 400);
      expect(find.text('third child'), findsOneWidget);
      await tester.offsetDrag(find.byKey(thirdHandleKey), dy: 51);
      await tester.pumpAndSettle();
      expect(controller!.height, 300);
      expect(find.text('second child'), findsOneWidget);
      await tester.offsetDrag(find.byKey(secondHandleKey), dy: -149);
      await tester.pumpAndSettle();
      expect(controller!.height, 400);
      expect(find.text('first child'), findsNothing);
      expect(find.text('second child'), findsOneWidget);
      expect(find.text('third child'), findsOneWidget);

      // between _thirdChild(400) and _thirdChild(500)
      await tester.offsetDrag(find.byKey(thirdHandleKey), dy: -50);
      await tester.pumpAndSettle();
      expect(controller!.height, 500);
      expect(find.text('third child'), findsOneWidget);
      await tester.offsetDrag(find.byKey(thirdHandleKey), dy: 50);
      await tester.pumpAndSettle();
      expect(controller!.height, 500);
      expect(find.text('third child'), findsOneWidget);
      await tester.offsetDrag(find.byKey(thirdHandleKey), dy: 51);
      await tester.pumpAndSettle();
      expect(controller!.height, 400);
      expect(find.text('third child'), findsOneWidget);
      await tester.offsetDrag(find.byKey(thirdHandleKey), dy: -149);
      await tester.pumpAndSettle();
      expect(controller!.height, 500);
      expect(find.text('first child'), findsNothing);
      expect(find.text('second child'), findsNothing);
      expect(find.text('third child'), findsOneWidget);

      // over _thirdChild(500)
      await tester.offsetDrag(find.byKey(thirdHandleKey), dy: -50);
      await tester.pumpAndSettle();
      expect(controller!.height, 500);
      expect(find.text('first child'), findsNothing);
      expect(find.text('second child'), findsNothing);
      expect(find.text('third child'), findsOneWidget);
    });
  });
}
