import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_google_places/home/home.dart';

import '../../helpers/helpers.dart';

class _MockPlacesBloc extends MockBloc<PlacesEvent, PlacesState>
    implements PlacesBloc {}

void main() {
  group('HomePage', () {
    late PlacesBloc placesBloc;

    setUp(() {
      placesBloc = _MockPlacesBloc();
      when(() => placesBloc.state).thenReturn(const PlacesState());
    });

    testWidgets('renders HomeBodySwitcher', (tester) async {
      await tester.pumpApp(const HomePage());

      expect(find.byType(HomeBodySwitcher), findsOneWidget);
    });
  });
}
