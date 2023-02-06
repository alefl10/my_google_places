import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_places_repo/google_places_repo.dart';
import 'package:shimmer/shimmer.dart';

class PlaceThumbnail extends StatelessWidget {
  const PlaceThumbnail({super.key, this.photoReference});

  final String? photoReference;

  @override
  Widget build(BuildContext context) {
    final hasImage = photoReference != null && photoReference!.isNotEmpty;

    return Container(
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: !hasImage ? Border.all(width: 2, color: Colors.black87) : null,
      ),
      child: hasImage
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: context.read<GooglePlacesRepo>().getPlacePhotoUrl(
                      photoReference: photoReference!,
                    ),
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.blueGrey,
                  child: Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            )
          : const Center(child: Icon(Icons.place_outlined, size: 32)),
    );
  }
}
