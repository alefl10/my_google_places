import 'package:flutter/material.dart';
import 'package:my_google_places/place_thumbnail/place_thumbnail.dart';

class PlaceDetailsPhotoCarousel extends StatelessWidget {
  const PlaceDetailsPhotoCarousel({super.key, required this.photoUrls});

  final List<String> photoUrls;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            scrollDirection: Axis.horizontal,
            itemCount: photoUrls.length,
            itemBuilder: (context, index) => SizedBox(
              width: 100,
              child: PlaceThumbnail(photoReference: photoUrls[index]),
            ),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
