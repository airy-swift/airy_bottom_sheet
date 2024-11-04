import 'dart:math';

import 'package:airy_bottom_sheet/airy_bottom_sheet.dart';
import 'package:airy_bottom_sheet/src/extension/list.dart';
import 'package:airy_bottom_sheet/src/extension/list_double.dart';
import 'package:airy_bottom_sheet/src/model/front_switch_data.dart';

final class AiryBottomSheetValue {
  const AiryBottomSheetValue._({
    required this.height,
    required this.magnetPoints,
    required this.frontSwitchData,
  });

  factory AiryBottomSheetValue({
    required double height,
    required List<List<double>> magnetPoints,
  }) {
    final flatten = magnetPoints.expand((v) => v);
    assert(flatten.isAscending);

    return AiryBottomSheetValue._(
      height: height,
      magnetPoints: magnetPoints,
      frontSwitchData: FrontSwitchData.empty(),
    );
  }

  final double height;

  /// when user release the scroll gesture, [AiryBottomSheet] will correct height to the [magnetPoints]
  ///   1. [magnetPoints] length must be the same as [AiryBottomSheet.switchChildren] length.
  ///   2. Numbers must be in ascending order.
  final List<List<double>> magnetPoints;

  final FrontSwitchData frontSwitchData;

  AiryBottomSheetValue copyWith({
    double? height,
    List<List<double>>? magnetPoints,
  }) {
    final heightValue = height ?? this.height;
    return AiryBottomSheetValue._(
      height: heightValue,
      magnetPoints: magnetPoints ?? this.magnetPoints,
      frontSwitchData: findSwitchDataInNestedList(heightValue),
    );
  }

  FrontSwitchData findSwitchDataInNestedList(double target) {
    if (magnetPoints.isEmpty || magnetPoints[0].isEmpty) {
      throw ArgumentError('The list cannot be empty.');
    }

    final frontSwitchData = FrontSwitchData.empty();
    double minDifference1 = (magnetPoints[0][0] - target).abs();
    double minDifference2 = minDifference1;

    for (int i = 0; i < magnetPoints.length; i++) {
      final subList = magnetPoints[i];
      for (final value in subList) {
        final difference = (value - target).abs();

        if (difference <= minDifference1) {
          minDifference2 = minDifference1;
          minDifference1 = difference;
          frontSwitchData.closestIndex = i;
        } else if (difference < minDifference2 && difference != minDifference1) {
          minDifference2 = difference;
          frontSwitchData.nextIndex = i;
        }
      }
    }

    if (magnetPoints.length != 1 && //
        frontSwitchData.isSameIndex &&
        magnetPoints[frontSwitchData.closestIndex].length == 1) //
    {
      final prevIdxValue = magnetPoints.safeElementAtOrNull(frontSwitchData.closestIndex - 1)?.reduce((a, b) => (a - target).abs() < (b - target).abs() ? a : b);
      final nextIdxValue = magnetPoints.safeElementAtOrNull(frontSwitchData.closestIndex + 1)?.reduce((a, b) => (a - target).abs() < (b - target).abs() ? a : b);
      final lower = min(prevIdxValue ?? double.infinity, nextIdxValue ?? double.infinity);
      if (lower == prevIdxValue) {
        frontSwitchData.nextIndex = frontSwitchData.closestIndex - 1;
      } else {
        frontSwitchData.nextIndex = frontSwitchData.closestIndex + 1;
      }
    }

    if (!frontSwitchData.isSameIndex) {
      final closestValue1 = magnetPoints[frontSwitchData.closestIndex].reduce((a, b) => (a - target).abs() < (b - target).abs() ? a : b);
      final closestValue2 = magnetPoints[frontSwitchData.nextIndex].reduce((a, b) => (a - target).abs() < (b - target).abs() ? a : b);

      final lower = min(closestValue1, closestValue2);
      final diff = (target - lower) / (closestValue1 - closestValue2).abs();
      frontSwitchData.distanceRatio = diff;
    }

    return frontSwitchData;
  }
}
