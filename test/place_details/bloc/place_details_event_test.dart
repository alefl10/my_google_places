import 'package:flutter_test/flutter_test.dart';
import 'package:my_google_places/place_details/place_details.dart';

void main() {
  group('PlaceDetailsEvent', () {
    group('PlaceDetailsDataRequested', () {
      test('supports value comparison', () {
        expect(
          const PlaceDetailsDataRequested().props,
          const PlaceDetailsDataRequested().props,
        );
      });
    });
  });
}
