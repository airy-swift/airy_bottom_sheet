import 'dart:math';

/// [FrontSwitchData] is used as a reference to switch the [AiryBottomSheet.switchChildren].
final class FrontSwitchData {
  FrontSwitchData(this._closestIndex, this.nextIndex, this._distanceRatio);

  /// index of the [AiryBottomSheet.switchChildren] closest to [AiryBottomSheetController.height]
  int _closestIndex;

  /// the next to [_closestIndex].
  int nextIndex;

  /// Ratio of [AiryBottomSheetController.height]'s distance to [_closestIndex] and [nextIndex]
  double _distanceRatio;

  /// ------------------------------------------------------------
  /// getter and setter
  /// ------------------------------------------------------------

  int get closestIndex => _closestIndex;

  set closestIndex(int newValue) {
    nextIndex = _closestIndex;
    _closestIndex = newValue;
  }

  double get distanceRatio => _distanceRatio;

  set distanceRatio(double value) => _distanceRatio = min(1, max(value, 0));

  get isSameIndex => _closestIndex == nextIndex;
}
