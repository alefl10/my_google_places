import 'package:flutter_test/flutter_test.dart';
import 'package:my_google_places/home/home.dart';

void main() {
  group('PlacesEvent', () {
    group('PlacesNearbySearched', () {
      test('supports value comparison', () {
        const eventA = PlacesNearbySearched(value: 'value');
        const eventB = PlacesNearbySearched(value: '');

        expect(eventA, isNot(eventB));
      });
    });
  });
}
