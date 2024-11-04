import 'dart:math';

import 'package:airy_bottom_sheet/src/controller/airy_bottom_sheet_value.dart';
import 'package:flutter/material.dart';

final class AiryBottomSheetController extends ValueNotifier<AiryBottomSheetValue> {
  AiryBottomSheetController({
    required double initialHeight,
    required List<List<double>> magnetPoints,
    this.maxHeight,
    this.minHeight = 0,
  }) : super(AiryBottomSheetValue(
          height: initialHeight,
          magnetPoints: magnetPoints,
        ));

  final double? maxHeight;
  final double minHeight;

  double get height => value.height;

  bool get grabbingHandle => value.grabbingHandle;

  set height(double v) {
    final heightValue = max<double>(0, v);
    final result = max<double>(minHeight, min<double>(maxHeight ?? double.infinity, heightValue));
    value = value.copyWith(height: result);
  }

  set grabbingHandle(bool v) {
    value = value.copyWith(grabbingHandle: v);
  }

  set magnetPoints(List<List<double>> v) {
    final currentHeight = value.height;

    final flatten = v.expand((v) => v);
    assert(flatten.isNotEmpty);
    final closest = flatten.reduce((lhs, rhs) => (lhs - currentHeight).abs() < (rhs - currentHeight).abs() ? lhs : rhs);
    value = value.copyWith(magnetPoints: v, height: closest);
  }

  double? dragStartHeightCache;
  double? dragUpdateStartCache;
  bool isDragging = false;

  void _clearProperties() {
    isDragging = false;
    dragStartHeightCache = null;
    dragUpdateStartCache = null;
  }

  void onDragStart(PointerDownEvent? event) {
    isDragging = true;
    dragStartHeightCache = height;
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    if (isDragging == false) {
      _clearProperties();
      return;
    }
    dragUpdateStartCache ??= details.localPosition.dy;
    height = (dragStartHeightCache ?? 0) + (dragUpdateStartCache ?? 0) - details.localPosition.dy;
  }

  void onVerticalDragEnd(DragEndDetails details) {
    _clearProperties();
    final closestHeight = value.magnetPoints[value.frontSwitchData.closestIndex].reduce(
      (lhs, rhs) => (lhs - height).abs() < (rhs - height).abs() ? lhs : rhs,
    );
    height = closestHeight;
  }
}
