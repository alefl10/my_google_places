import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_places_models/google_places_models.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_google_places/home/home.dart';
import 'package:my_google_places/permission/permission.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../helpers/helpers.dart';

class _MockPermissionBloc extends MockBloc<PermissionEvent, PermissionState>
    implements PermissionBloc {}

class _MockPlacesBloc extends MockBloc<PlacesEvent, PlacesState>
    implements PlacesBloc {}

void main() {
  group('HomeView', () {
    late PermissionBloc permissionBloc;
    late PlacesBloc placesBloc;

    setUp(() {
      permissionBloc = _MockPermissionBloc();
      when(() => permissionBloc.state).thenReturn(
        const PermissionState(
          locationPermissionStatus: PermissionStatus.granted,
        ),
      );
      placesBloc = _MockPlacesBloc();
      when(() => placesBloc.state).thenReturn(
        const PlacesState(status: PlacesStatus.loading),
      );
    });

    group('renders', () {
      testWidgets(
        'noPlacesFoundText when now places were found',
        (tester) async {
          when(() => placesBloc.state).thenReturn(
            const PlacesState(status: PlacesStatus.success),
          );
          await tester.pumpHomeView(
            permissionBloc: permissionBloc,
            placesBloc: placesBloc,
          );
          final l10n = await getAppLocalizations();

          expect(find.text(l10n.noPlacesFoundText), findsOneWidget);
        },
      );

      testWidgets(
        'two PlaceTile when PlacesState has two places',
        (tester) async {
          const place = GooglePlace(
            placeId: '',
            name: 'name',
            vicinity: '',
            rating: 5,
            userRatingsTotal: 1,
          );
          when(() => placesBloc.state).thenReturn(
            const PlacesState(
              status: PlacesStatus.success,
              places: [place, place],
            ),
          );
          await tester.pumpHomeView(
            permissionBloc: permissionBloc,
            placesBloc: placesBloc,
          );

          expect(find.byType(PlaceTile), findsNWidgets(2));
        },
      );
    });

    group('adds', () {
      testWidgets(
        'PlacesNearbySearched when text is entered',
        (tester) async {
          const text = 'text';
          await tester.pumpHomeView(
            permissionBloc: permissionBloc,
            placesBloc: placesBloc,
          );
          await tester.enterText(find.byType(TextField), text);

          verify(
            () => placesBloc.add(const PlacesNearbySearched(value: text)),
          ).called(1);
        },
      );

      testWidgets(
        'PermissionLocationRequested when PlacesStatus switches '
        'to locationDisabled',
        (tester) async {
          whenListen(
            placesBloc,
            Stream<PlacesState>.fromIterable([
              const PlacesState(),
              const PlacesState(
                status: PlacesStatus.locationDisabled,
              ),
            ]),
          );
          await tester.pumpHomeView(
            permissionBloc: permissionBloc,
            placesBloc: placesBloc,
          );

          verify(
            () => permissionBloc.add(const PermissionLocationRequested()),
          ).called(1);
        },
      );
    });
  });
}

extension on WidgetTester {
  Future<void> pumpHomeView({
    required PermissionBloc permissionBloc,
    required PlacesBloc placesBloc,
  }) {
    return pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: permissionBloc),
          BlocProvider.value(value: placesBloc),
        ],
        child: const Scaffold(
          body: HomeView(),
        ),
      ),
    );
  }
}
