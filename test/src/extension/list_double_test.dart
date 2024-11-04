import 'package:flutter_test/flutter_test.dart';
import 'package:airy_bottom_sheet/src/extension/list_double.dart';

void main() {
  test('test [ListDoubleEx.isAscending]: confirm checking isAscending for List<double>', () {
    expect(<double>[0].isAscending, true);
    expect(<double>[0, 1].isAscending, true);
    expect(<double>[0, 1, 2].isAscending, true);
    expect(<double>[0, 1, 2].isAscending, true);

    expect(<double>[2, 1].isAscending, false);
    expect(<double>[2, 1, 0].isAscending, false);
    expect(<double>[2, 0].isAscending, false);
  });
}
