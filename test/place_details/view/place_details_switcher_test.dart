import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_places_models/google_places_models.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_google_places/place_details/place_details.dart';

import '../../helpers/helpers.dart';

class _MockPlaceDetailsBloc
    extends MockBloc<PlaceDetailsEvent, PlaceDetailsState>
    implements PlaceDetailsBloc {}

void main() {
  group('PlaceDetailsSwitcher', () {
    const place = GooglePlace();
    late PlaceDetailsBloc placeDetailsBloc;

    setUp(() {
      placeDetailsBloc = _MockPlaceDetailsBloc();
      when(() => placeDetailsBloc.state).thenReturn(
        const PlaceDetailsState(place: place, status: PlaceDetailsStatus.error),
      );
    });

    testWidgets(
      'renders genericErrorMessage PlaceDetailsStatus.error',
      (tester) async {
        await tester.pumpPlaceDetailsSwitcher(
          placeDetailsBloc: placeDetailsBloc,
        );
        final l10n = await getAppLocalizations();

        expect(find.text(l10n.genericErrorMessage), findsOneWidget);
      },
    );

    testWidgets(
      'adds PlaceDetailsDataRequested on tryAgainText button tap',
      (tester) async {
        await tester.pumpPlaceDetailsSwitcher(
          placeDetailsBloc: placeDetailsBloc,
        );
        final l10n = await getAppLocalizations();
        await tester.tap(find.text(l10n.tryAgainText));
        await tester.pumpAndSettle();

        verify(
          () => placeDetailsBloc.add(const PlaceDetailsDataRequested()),
        ).called(1);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpPlaceDetailsSwitcher({
    required PlaceDetailsBloc placeDetailsBloc,
  }) {
    return pumpApp(
      BlocProvider.value(
        value: placeDetailsBloc,
        child: const Scaffold(body: PlaceDetailsSwitcher()),
      ),
    );
  }
}
