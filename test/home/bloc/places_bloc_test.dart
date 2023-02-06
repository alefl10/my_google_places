import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_client/geolocator_client.dart';
import 'package:google_places_models/google_places_models.dart';
import 'package:google_places_repo/google_places_repo.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_google_places/home/home.dart';

import '../../helpers/helpers.dart';

class _FakePosition extends Fake implements Position {
  @override
  double get latitude => 0;

  @override
  double get longitude => 0;
}

class _FakeGeometry extends Fake implements Geometry {}

void main() {
  group('PlacesBloc', () {
    const place = GooglePlace(placeId: '');
    late GeolocatorClient geolocatorClient;
    late GooglePlacesRepo googlePlacesRepo;

    setUp(() {
      geolocatorClient = MockGeolocatorClient();
      googlePlacesRepo = MockGooglePlacesRepo();
    });

    setUpAll(() {
      registerFallbackValue(_FakePosition());
      registerFallbackValue(_FakeGeometry());
    });

    PlacesBloc buildBloc() => PlacesBloc(
          googlePlacesRepo: googlePlacesRepo,
          geolocatorClient: geolocatorClient,
        );

    test('initial state is PlacesState', () {
      expect(buildBloc().state, const PlacesState());
    });

    group('PlacesNearbySearched', () {
      blocTest<PlacesBloc, PlacesState>(
        'emits initial PlacesState if event value is empty .',
        build: buildBloc,
        act: (bloc) => bloc.add(const PlacesNearbySearched(value: '')),
        expect: () => const <PlacesState>[PlacesState()],
      );

      blocTest<PlacesBloc, PlacesState>(
        'emits state with loading status and then locationDisabled if '
        'GeolocatorClientLocationDisabledException is thrown.',
        build: buildBloc,
        setUp: () {
          when(() => geolocatorClient.getCurrentPosition()).thenThrow(
            const GeolocatorClientLocationDisabledException(''),
          );
        },
        act: (bloc) => bloc.add(const PlacesNearbySearched(value: 'value')),
        expect: () => const <PlacesState>[
          PlacesState(status: PlacesStatus.loading),
          PlacesState(status: PlacesStatus.locationDisabled),
        ],
      );

      blocTest<PlacesBloc, PlacesState>(
        'emits state with loading status and then failure if '
        'any Exception is thrown.',
        build: buildBloc,
        setUp: () {
          when(() => geolocatorClient.getCurrentPosition()).thenThrow(
            Exception(''),
          );
        },
        act: (bloc) => bloc.add(const PlacesNearbySearched(value: 'value')),
        expect: () => const <PlacesState>[
          PlacesState(status: PlacesStatus.loading),
          PlacesState(status: PlacesStatus.failure),
        ],
      );

      blocTest<PlacesBloc, PlacesState>(
        'emits state with loading status and then success with found places if '
        'the process completes successfully.',
        setUp: () {
          when(() => geolocatorClient.getCurrentPosition()).thenAnswer(
            (invocation) async => _FakePosition(),
          );
          when(
            () => googlePlacesRepo.nearbySearch(
              keyword: any(named: 'keyword'),
              location: any(named: 'location'),
            ),
          ).thenAnswer((invocation) async => [place]);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const PlacesNearbySearched(value: 'value')),
        wait: const Duration(milliseconds: 305),
        expect: () => const [
          PlacesState(status: PlacesStatus.loading),
          PlacesState(status: PlacesStatus.success, places: [place]),
        ],
      );
    });
  });
}
