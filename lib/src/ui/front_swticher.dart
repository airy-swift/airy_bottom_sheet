import 'package:airy_bottom_sheet/src/model/front_switch_data.dart';
import 'package:flutter/material.dart';

/// frontSwitchDataとswitchChildrenのcontrollerを作成
/// opacityは別でとりたい
class FrontSwitcher extends StatelessWidget {
  const FrontSwitcher({
    super.key,
    required this.frontSwitchData,
    required this.switchChildren,
  });

  final FrontSwitchData frontSwitchData;
  final List<Widget> switchChildren;

  @override
  Widget build(BuildContext context) {
    var first = switchChildren[frontSwitchData.closestIndex];
    Widget? second;
    bool ignoreSecond = true;
    if (!frontSwitchData.isSameIndex) {
      if (frontSwitchData.closestIndex > frontSwitchData.nextIndex) {
        second = switchChildren[frontSwitchData.nextIndex];
      } else {
        second = first;
        first = switchChildren[frontSwitchData.nextIndex];
        ignoreSecond = false;
      }
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        IgnorePointer(
          ignoring: !ignoreSecond,
          child: Opacity(
            opacity: frontSwitchData.distanceRatio,
            child: first,
          ),
        ),
        if (second != null) ...[
          IgnorePointer(
            ignoring: ignoreSecond,
            child: Opacity(
              opacity: 1 - frontSwitchData.distanceRatio,
              child: second,
            ),
          ),
        ]
      ],
    );
  }
}
