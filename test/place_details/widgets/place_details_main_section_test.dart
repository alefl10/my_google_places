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
  group('PlaceDetailsMainSection', () {
    const place = GooglePlace(
      placeId: 'a',
      name: 'name',
      vicinity: '',
      editorialSummary: EditorialSummary(overview: ''),
      photos: [
        PlacePhoto(height: 50, width: 50, photoReference: 'photoReference'),
      ],
    );
    late PlaceDetailsBloc placeDetailsBloc;

    setUp(() {
      placeDetailsBloc = _MockPlaceDetailsBloc();
      when(() => placeDetailsBloc.state).thenReturn(
        const PlaceDetailsState(place: place),
      );
    });

    testWidgets('shows noReviewsText if rating is null', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: BlocProvider.value(
            value: placeDetailsBloc,
            child: const PlaceDetailsMainSection(),
          ),
        ),
      );
      final l10n = await getAppLocalizations();

      expect(find.text(l10n.noReviewsText), findsOneWidget);
    });
  });
}
