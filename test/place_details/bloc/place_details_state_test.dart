import 'package:flutter_test/flutter_test.dart';
import 'package:google_places_models/google_places_models.dart';
import 'package:my_google_places/place_details/place_details.dart';

void main() {
  group('PlaceDetailsState', () {
    test('supports value comparison', () {
      const place = GooglePlace();
      const stateA = PlaceDetailsState(place: place);
      final stateB = stateA.copyWith();
      final stateC = stateA.copyWith(status: PlaceDetailsStatus.success);

      expect(stateA, stateB);
      expect(stateA, isNot(stateC));
    });
  });
}
