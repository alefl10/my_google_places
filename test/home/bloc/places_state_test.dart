import 'package:flutter_test/flutter_test.dart';
import 'package:my_google_places/home/home.dart';

void main() {
  group('PlacesState', () {
    test('supports value comparison', () {
      const stateA = PlacesState(status: PlacesStatus.loading);
      final stateB = stateA.copyWith();
      final stateC = stateA.copyWith(status: PlacesStatus.success);

      expect(stateA, stateB);
      expect(stateA, isNot(stateC));
    });
  });
}
