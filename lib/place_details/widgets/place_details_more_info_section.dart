import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_google_places/l10n/l10n.dart';
import 'package:my_google_places/place_details/place_details.dart';

class PlaceDetailsMoreInfoSection extends StatelessWidget {
  const PlaceDetailsMoreInfoSection({super.key});

  Icon _getIcon({required bool? flag}) {
    if (flag != null) {
      return flag
          ? const Icon(
              Icons.check,
              color: Colors.greenAccent,
              size: 20,
            )
          : const Icon(
              Icons.do_not_disturb_sharp,
              color: Colors.redAccent,
              size: 20,
            );
    } else {
      return const Icon(
        Icons.question_mark_rounded,
        color: Colors.grey,
        size: 20,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final place = context.select((PlaceDetailsBloc bloc) => bloc.state.place);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.moreInfoText,
          style: textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          '${l10n.priceWord} '
          '${place.priceLevel != null ? List.generate(place.priceLevel!.index, (_) => r'$').join() : l10n.unknownWord}', // ignore: lines_longer_than_80_chars
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Flexible(child: Text(l10n.curbsidePickupWord)),
            const SizedBox(width: 4),
            _getIcon(flag: place.curbsidePickup),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Flexible(child: Text(l10n.deliveryWord)),
            const SizedBox(width: 4),
            _getIcon(flag: place.delivery),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Flexible(child: Text(l10n.dineInWord)),
            const SizedBox(width: 4),
            _getIcon(flag: place.dineIn),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Flexible(child: Text(l10n.takeoutWord)),
            const SizedBox(width: 4),
            _getIcon(flag: place.takeout),
          ],
        )
      ],
    );
  }
}
