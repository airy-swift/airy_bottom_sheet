import 'dart:math';

import 'package:airy_bottom_sheet/src/controller/airy_bottom_sheet_value.dart';
import 'package:airy_bottom_sheet/src/extension/list_double.dart';
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

  /// ------------------------------------------------------------
  /// bottom sheet handling properties
  /// ------------------------------------------------------------

  final double? maxHeight;
  final double minHeight;

  double get height => value.height;

  set height(double v) {
    final heightValue = max<double>(0, v);
    final result = max<double>(minHeight, min<double>(maxHeight ?? double.infinity, heightValue));
    value = value.copyWith(height: result);
  }

  /// update [value.magnetPoints] and correct [value.height]
  set magnetPoints(List<List<double>> v) {
    final currentHeight = value.height;
    final flatten = v.expand((v) => v);

    assert(flatten.isNotEmpty);
    assert(flatten.isAscending);
    assert(minHeight <= flatten.first);
    assert(flatten.last <= (maxHeight ?? double.infinity));

    final closest = flatten.reduce((lhs, rhs) => (lhs - currentHeight).abs() < (rhs - currentHeight).abs() ? lhs : rhs);
    value = value.copyWith(magnetPoints: v, height: closest);
  }

  /// ------------------------------------------------------------
  /// drag properties
  /// ------------------------------------------------------------

  double? dragStartHeightCache;
  double? dragUpdateStartCache;
  bool isDragging = false;

  @visibleForTesting
  void clearDragProperties() {
    isDragging = false;
    dragStartHeightCache = null;
    dragUpdateStartCache = null;
  }

  /// ------------------------------------------------------------
  /// drag events
  /// ------------------------------------------------------------

  void onDragStart(PointerDownEvent? event) {
    isDragging = true;
    dragStartHeightCache = height;
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    if (isDragging == false) {
      clearDragProperties();
      return;
    }
    dragUpdateStartCache ??= details.localPosition.dy;
    height = (dragStartHeightCache ?? 0) + (dragUpdateStartCache ?? 0) - details.localPosition.dy;
  }

  void onVerticalDragEnd(DragEndDetails details) {
    clearDragProperties();
    final closestHeight = value.magnetPoints[value.frontSwitchData.closestIndex].reduce(
      (lhs, rhs) => (lhs - height).abs() < (rhs - height).abs() ? lhs : rhs,
    );
    height = closestHeight;
  }
}
