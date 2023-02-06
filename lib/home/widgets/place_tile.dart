import 'package:flutter/material.dart';
import 'package:google_places_models/google_places_models.dart';
import 'package:my_google_places/l10n/l10n.dart';
import 'package:my_google_places/place_details/place_details.dart';
import 'package:my_google_places/place_thumbnail/place_thumbnail.dart';

class PlaceTile extends StatelessWidget {
  const PlaceTile({super.key, required this.place});

  final GooglePlace place;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(PlaceDetailsPage.route(place));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlaceThumbnail(
              photoReference: place.photos?.first.photoReference,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          place.name!,
                          style: textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(place.vicinity ?? place.formattedAddress!),
                  const SizedBox(height: 4),
                  if (place.rating != null && place.userRatingsTotal! > 0)
                    Text(
                      l10n.placeRatingFromReviewsText(
                        place.rating!,
                        place.userRatingsTotal!,
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
