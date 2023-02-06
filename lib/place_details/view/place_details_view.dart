import 'package:flutter/material.dart';
import 'package:my_google_places/place_details/place_details.dart';

class PlaceDetailsView extends StatelessWidget {
  const PlaceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          PlaceDetailsMainSection(),
          SizedBox(height: 8),
          PlaceDetailsMoreInfoSection(),
          SizedBox(height: 8),
          PlaceDetailsOpeningHoursSection()
        ],
      ),
    );
  }
}
