import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_google_places/l10n/l10n.dart';
import 'package:my_google_places/place_details/place_details.dart';
import 'package:my_google_places/place_details/widgets/place_details_photo_carousel.dart';

class PlaceDetailsMainSection extends StatelessWidget {
  const PlaceDetailsMainSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final place = context.select((PlaceDetailsBloc bloc) => bloc.state.place);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.detailsWord,
          style: textTheme.headlineSmall,
        ),
        Column(
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.reviews_rounded,
                  color: Colors.blueGrey,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    place.rating != null && place.rating! > 0
                        ? l10n.placeRatingFromReviewsText(
                            place.rating!,
                            place.userRatingsTotal!,
                          )
                        : l10n.noReviewsText,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.pin_drop_rounded,
              color: Colors.blueGrey,
            ),
            const SizedBox(width: 4),
            Flexible(child: Text(place.vicinity ?? place.formattedAddress!)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(
              Icons.phone_rounded,
              color: Colors.blueGrey,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(place.internationalPhoneNumber ?? l10n.unknownWord),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(
              Icons.web_rounded,
              color: Colors.blueGrey,
            ),
            const SizedBox(width: 4),
            Flexible(child: Text(place.website ?? l10n.unknownWord)),
          ],
        ),
        if (place.editorialSummary != null)
          Column(
            children: [
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.info_rounded,
                    color: Colors.blueGrey,
                  ),
                  const SizedBox(width: 4),
                  Flexible(child: Text(place.editorialSummary!.overview!)),
                ],
              ),
            ],
          ),
        if (place.photos != null && place.photos!.isNotEmpty)
          Column(
            children: [
              const SizedBox(height: 16),
              PlaceDetailsPhotoCarousel(
                photoUrls: [
                  ...place.photos!.map((photo) => photo.photoReference),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
