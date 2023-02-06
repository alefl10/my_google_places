import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:my_google_places/place_details/place_details.dart';

import '../../helpers/helpers.dart';

void main() {
  testWidgets('navigates to PlaceDetailsPage on tap', (tester) async {
    await mockNetworkImages(() async {
      await tester.pumpApp(
        const Scaffold(
          body: PlaceDetailsHeader(
            name: 'name',
            photoReference: 'url',
          ),
        ),
      );
    });
    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });
}
