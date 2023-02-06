import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_google_places/l10n/l10n.dart';
import 'package:my_google_places/place_details/place_details.dart';

class PlaceDetailsOpeningHoursSection extends StatelessWidget {
  const PlaceDetailsOpeningHoursSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final place = context.select((PlaceDetailsBloc bloc) => bloc.state.place);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.openingHoursText,
          style: textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        if (place.openingHours != null &&
            place.openingHours?.weekdayText != null)
          ...place.openingHours!.weekdayText!.map(
            (text) => Column(
              children: [
                Text('${text[0].toUpperCase()}${text.substring(1)}'),
                const SizedBox(height: 4),
              ],
            ),
          )
        else
          Text(l10n.noInfoAvailableText),
      ],
    );
  }
}
