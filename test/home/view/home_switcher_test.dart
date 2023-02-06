import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
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
  group('HomeBodySwitcher', () {
    late PermissionBloc permissionBloc;
    late PlacesBloc placesBloc;

    setUp(() {
      permissionBloc = _MockPermissionBloc();
      when(() => permissionBloc.state).thenReturn(const PermissionState());
      placesBloc = _MockPlacesBloc();
      when(() => placesBloc.state).thenReturn(const PlacesState());
    });

    group('renders', () {
      testWidgets(
        'HomeView when PermissionStatus.granted',
        (tester) async {
          when(() => permissionBloc.state).thenReturn(
            const PermissionState(
              locationPermissionStatus: PermissionStatus.granted,
            ),
          );
          await tester.pumpHomeBodySwitcher(
            placesBloc: placesBloc,
            permissionBloc: permissionBloc,
          );

          expect(find.byType(HomeView), findsOneWidget);
        },
      );

      testWidgets(
        'HomeView when PermissionStatus.limited',
        (tester) async {
          when(() => permissionBloc.state).thenReturn(
            const PermissionState(
              locationPermissionStatus: PermissionStatus.limited,
            ),
          );
          await tester.pumpHomeBodySwitcher(
            placesBloc: placesBloc,
            permissionBloc: permissionBloc,
          );

          expect(find.byType(HomeView), findsOneWidget);
        },
      );

      testWidgets(
        'LocationNotAvailableBody when PermissionStatus.restricted',
        (tester) async {
          when(() => permissionBloc.state).thenReturn(
            const PermissionState(
              locationPermissionStatus: PermissionStatus.restricted,
            ),
          );
          await tester.pumpHomeBodySwitcher(
            placesBloc: placesBloc,
            permissionBloc: permissionBloc,
          );

          expect(find.byType(LocationNotAvailableBody), findsOneWidget);
        },
      );

      testWidgets(
        'LocationNotAvailableBody when PermissionStatus.denied',
        (tester) async {
          when(() => permissionBloc.state).thenReturn(
            const PermissionState(
              locationPermissionStatus: PermissionStatus.denied,
            ),
          );
          await tester.pumpHomeBodySwitcher(
            placesBloc: placesBloc,
            permissionBloc: permissionBloc,
          );

          expect(find.byType(LocationNotAvailableBody), findsOneWidget);
        },
      );

      testWidgets(
        'LocationNotAvailableBody when PermissionStatus.permanentlyDenied',
        (tester) async {
          when(() => permissionBloc.state).thenReturn(
            const PermissionState(
              locationPermissionStatus: PermissionStatus.permanentlyDenied,
            ),
          );
          await tester.pumpHomeBodySwitcher(
            placesBloc: placesBloc,
            permissionBloc: permissionBloc,
          );

          expect(find.byType(LocationNotAvailableBody), findsOneWidget);
        },
      );

      testWidgets(
        'nothing when state.locationPermissionStatus is null',
        (tester) async {
          await tester.pumpHomeBodySwitcher(
            placesBloc: placesBloc,
            permissionBloc: permissionBloc,
          );

          expect(find.byType(HomeView), findsNothing);
          expect(find.byType(LocationNotAvailableBody), findsNothing);
        },
      );
    });

    group('shows', () {
      testWidgets('SnackBar with open settings error text', (tester) async {
        whenListen(
          permissionBloc,
          Stream<PermissionState>.fromIterable([
            const PermissionState(),
            const PermissionState(didOpenSettings: false),
          ]),
        );
        await tester.pumpHomeBodySwitcher(
          placesBloc: placesBloc,
          permissionBloc: permissionBloc,
        );
        final l10n = await getAppLocalizations();
        await tester.pumpAndSettle();

        expect(find.text(l10n.openSettingsErrorText), findsOneWidget);
      });

      testWidgets(
        'SnackBar with location permission not granted text',
        (tester) async {
          whenListen(
            permissionBloc,
            Stream<PermissionState>.fromIterable([
              const PermissionState(),
              const PermissionState(
                locationPermissionStatus: PermissionStatus.denied,
              ),
            ]),
          );
          await tester.pumpHomeBodySwitcher(
            placesBloc: placesBloc,
            permissionBloc: permissionBloc,
          );
          final l10n = await getAppLocalizations();
          await tester.pumpAndSettle();

          expect(
            find.text(l10n.locationPermissionNotGrantedText),
            findsOneWidget,
          );
        },
      );
    });
  });
}

extension on WidgetTester {
  Future<void> pumpHomeBodySwitcher({
    required PermissionBloc permissionBloc,
    required PlacesBloc placesBloc,
  }) {
    return pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: permissionBloc),
          BlocProvider.value(value: placesBloc),
        ],
        child: const Scaffold(body: HomeBodySwitcher()),
      ),
    );
  }
}
