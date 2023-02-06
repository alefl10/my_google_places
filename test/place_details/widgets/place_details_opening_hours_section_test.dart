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
  group('PlaceDetailsOpeningHoursSection', () {
    const place = GooglePlace(
      placeId: 'a',
      openingHours: PlaceOpeningHours(weekdayText: ['weekday']),
    );
    late PlaceDetailsBloc placeDetailsBloc;

    setUp(() {
      placeDetailsBloc = _MockPlaceDetailsBloc();
      when(() => placeDetailsBloc.state).thenReturn(
        const PlaceDetailsState(place: place),
      );
    });

    testWidgets(
      'shows openingHours weekdayText text if openingHours is not null',
      (tester) async {
        await tester.pumpApp(
          Scaffold(
            body: BlocProvider.value(
              value: placeDetailsBloc,
              child: const PlaceDetailsOpeningHoursSection(),
            ),
          ),
        );

        expect(find.text('Weekday'), findsOneWidget);
      },
    );
  });
}
