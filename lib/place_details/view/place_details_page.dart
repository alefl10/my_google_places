import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_places_models/google_places_models.dart';
import 'package:google_places_repo/google_places_repo.dart';
import 'package:my_google_places/l10n/l10n.dart';
import 'package:my_google_places/place_details/place_details.dart';

class PlaceDetailsPage extends StatelessWidget {
  const PlaceDetailsPage({super.key, required this.place});

  static String path = '/place_details';

  static Route<void> route(GooglePlace place) {
    return MaterialPageRoute<void>(
      settings: RouteSettings(name: path),
      builder: (context) => PlaceDetailsPage(place: place),
    );
  }

  final GooglePlace place;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.placeDetailsTitle),
      ),
      body: BlocProvider(
        create: (context) => PlaceDetailsBloc(
          place: place,
          googlePlacesRepo: context.read<GooglePlacesRepo>(),
        )..add(const PlaceDetailsDataRequested()),
        child: ListView(
          children: [
            PlaceDetailsHeader(
              name: place.name!,
              photoReference: place.photos?.first.photoReference,
            ),
            const PlaceDetailsSwitcher(),
          ],
        ),
      ),
    );
  }
}
