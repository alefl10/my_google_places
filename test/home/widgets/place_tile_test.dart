import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_places_models/google_places_models.dart';
import 'package:google_places_repo/google_places_repo.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:my_google_places/home/home.dart';
import 'package:my_google_places/place_details/place_details.dart';

import '../../helpers/helpers.dart';

class _MockGooglePlacesRepo extends Mock implements GooglePlacesRepo {
  @override
  String getPlacePhotoUrl({
    required String photoReference,
    int? maxWidth,
    int? minWidth,
  }) {
    return 'url';
  }
}

void main() {
  group('PlaceTile', () {
    const place = GooglePlace(
      placeId: 'a',
      name: 'name',
      vicinity: '',
      rating: 5,
      userRatingsTotal: 1,
      editorialSummary: EditorialSummary(overview: ''),
      photos: [
        PlacePhoto(height: 50, width: 50, photoReference: 'photoReference'),
        PlacePhoto(height: 50, width: 50, photoReference: 'photoReference'),
      ],
    );
    late GooglePlacesRepo googlePlacesRepo;

    setUp(() {
      googlePlacesRepo = _MockGooglePlacesRepo();
      when(
        () => googlePlacesRepo.getPlaceDetails(
          placeId: any(named: 'placeId'),
        ),
      ).thenAnswer((_) async => place);
    });

    testWidgets('navigates to PlaceDetailsPage on tap', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpApp(
          const Scaffold(body: PlaceTile(place: place)),
          googlePlacesRepo: googlePlacesRepo,
        );
        await tester.tap(find.byType(PlaceTile));
        await tester.pump();
        await tester.pump();
        expect(find.byType(PlaceDetailsPage), findsOneWidget);
      });
    });
  });
}
