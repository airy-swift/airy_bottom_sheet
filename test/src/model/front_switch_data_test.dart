import 'package:airy_bottom_sheet/src/model/front_switch_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test [FrontSwitchData]', () {
    // == test
    expect(FrontSwitchData(0, 1, 0.5) == FrontSwitchData(0, 1, 0.5), true);
    expect(FrontSwitchData(1, 0, 1) == FrontSwitchData(1, 0, 1), true);
    expect(FrontSwitchData(1, 0, 0.1) == FrontSwitchData(1, 0, 0.1), true);

    final data = FrontSwitchData(0, 1, 0);

    // closestIndex setter test
    expect(data.closestIndex, 0);
    expect(data.nextIndex, 1);

    data.closestIndex = 1;
    expect(data.closestIndex, 1);
    expect(data.nextIndex, 0);

    data.closestIndex = 3;
    expect(data.closestIndex, 3);
    expect(data.nextIndex, 1);

    // distanceRatio setter test
    expect(data.distanceRatio, 0);

    data.distanceRatio = 2;
    expect(data.distanceRatio, 1);

    data.distanceRatio = -1;
    expect(data.distanceRatio, 0);

    data.distanceRatio = 0.0001;
    expect(data.distanceRatio, 0.0001);

    data.distanceRatio = 0.9999;
    expect(data.distanceRatio, 0.9999);
  });
}
