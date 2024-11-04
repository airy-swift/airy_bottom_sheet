# AiryBottomSheet

Thanks for looking!

## WHAT'S THIS?

AiryBottomSheet is a very easy-to-use and stylish BottomSheet that seamlessly switches widgets by scrolling through the BottomSheet and adjusts like a magnet to the specified height when released.

[demo](https://github.com/user-attachments/assets/57ebb51b-0937-452d-ab03-7b9cf2014afe)

## HOW TO USE (Only 3 steps!)

### 1. Defines widgets wrapped in a Handle.

The Handle widget is required to adjust the height of the AiryBottomSheet.

```dart
Widget _firstChild() {
  return Column(
    children: [
      Handle(
        controller: _controller,
        child: Container(
          color: Colors.redAccent,
          height: 40,
        ),
      ),
      Expanded(
        child: Container(
          color: Colors.black,
        ),
      )
    ],
  );
}

Widget _secondChild() {
  return Handle(
    controller: _controller,
    child: Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.red,
          ),
        ),
      ],
    ),
  );
}
```

### 2. Prepare AiryBottomSheetController

- `initialHeight` is the initial height of the `AiryBottomSheet`.
- `magnetPoints` is the height that is adjusted when the scroll is released.
  - -> why the type of `magnetPoints` is `List<List<double>>` ??
    - This is in contrast to `AiryBottomSheet.switchChildren` described below, which uses the information in the corresponding index to determine the widget and height to be displayed.
- `maxHeight` is the maximum height of the `AiryBottomSheet`.
- `minHeight` is the minimum height of the `AiryBottomSheet`.

```dart
final _controller = AiryBottomSheetController(
  initialHeight: 100,
  magnetPoints: [
    [100],
    [200, 300],
    [400, 500],
  ],
  maxHeight: 530,
  minHeight: 80,
);
```

### 3. Call your AiryBottomSheet

- `_scaffoldKey` is `GlobalKey<ScaffoldState>`.
- `controller` is prepared in Section 2.
- `switchChildren` is paired with `AiryBottomSheetController.magnetPoints` and the corresponding index height and widget will be displayed on the `AiryBottomSheet`.
- `onDragAndAnimationEnd` is literal. :)✨

```dart
AiryBottomSheet.show(
  _scaffoldKey,
  controller: _controller,
  switchChildren: [
    _firstChild(),
    _secondChild(),
    _thirdChild(),
  ],
  onDragAndAnimationEnd: (height) {
    debugPrint(height.toString());
  },
);
```

## Have a question?

Write in issue!