import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_places_models/google_places_models.dart';
import 'package:google_places_repo/google_places_repo.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_google_places/place_details/place_details.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PlaceDetailsBloc', () {
    const place = GooglePlace(placeId: 'placeId');
    const placeWithDetails = GooglePlace(
      placeId: 'placeId',
      adrAddress: 'adrAddress',
    );
    late GooglePlacesRepo googlePlacesRepo;

    setUp(() {
      googlePlacesRepo = MockGooglePlacesRepo();
    });

    PlaceDetailsBloc buildBloc() => PlaceDetailsBloc(
          googlePlacesRepo: googlePlacesRepo,
          place: place,
        );

    test('initial state is PlaceDetailsState with place', () {
      expect(buildBloc().state, const PlaceDetailsState(place: place));
    });

    group('PlaceDetailsDataRequested', () {
      blocTest<PlaceDetailsBloc, PlaceDetailsState>(
        'emits state with loading status and then error when '
        'getPlacesDetails throws an Exception.',
        setUp: () {
          when(
            () => googlePlacesRepo.getPlaceDetails(
              placeId: any(named: 'placeId'),
            ),
          ).thenThrow(Exception());
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const PlaceDetailsDataRequested()),
        expect: () => const <PlaceDetailsState>[
          PlaceDetailsState(
            place: place,
            status: PlaceDetailsStatus.loading,
          ),
          PlaceDetailsState(
            place: place,
            status: PlaceDetailsStatus.error,
          ),
        ],
      );

      blocTest<PlaceDetailsBloc, PlaceDetailsState>(
        'emits state with loading status and then success with '
        'placeWithDetails getPlacesDetails completes successfully.',
        setUp: () {
          when(
            () => googlePlacesRepo.getPlaceDetails(
              placeId: any(named: 'placeId'),
            ),
          ).thenAnswer((_) async => placeWithDetails);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const PlaceDetailsDataRequested()),
        expect: () => const <PlaceDetailsState>[
          PlaceDetailsState(
            place: place,
            status: PlaceDetailsStatus.loading,
          ),
          PlaceDetailsState(
            place: placeWithDetails,
            status: PlaceDetailsStatus.success,
          ),
        ],
      );
    });
  });
}
