import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_places_repo/google_places_repo.dart';
import 'package:shimmer/shimmer.dart';

class PlaceDetailsHeader extends StatelessWidget {
  const PlaceDetailsHeader({
    super.key,
    required this.name,
    this.photoReference,
  });

  final String name;
  final String? photoReference;

  @override
  Widget build(BuildContext context) {
    final hasImage = photoReference != null && photoReference!.isNotEmpty;

    return Stack(
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: hasImage
              ? CachedNetworkImage(
                  imageUrl: context.read<GooglePlacesRepo>().getPlacePhotoUrl(
                        photoReference: photoReference!,
                        minWidth: 1024,
                        maxWidth: 2048,
                      ),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.blueGrey,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              : const Center(child: Icon(Icons.place_outlined, size: 64)),
        ),
        Container(
          height: 200,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.black12,
                Colors.black38,
                Colors.black54,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 32,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
