import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_google_places/home/home.dart';
import 'package:my_google_places/l10n/l10n.dart';
import 'package:my_google_places/permission/permission.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<PlacesBloc, PlacesState>(
      listenWhen: (pre, cur) => pre.status != cur.status,
      listener: (context, state) {
        if (state.status == PlacesStatus.locationDisabled) {
          context.read<PermissionBloc>().add(
                const PermissionLocationRequested(),
              );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                context
                    .read<PlacesBloc>()
                    .add(PlacesNearbySearched(value: value));
              },
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: l10n.searchPlaceHintText,
                prefixIcon: const Icon(Icons.place_rounded),
                suffixIcon: state.status == PlacesStatus.loading
                    ? Transform.scale(
                        scale: 0.4,
                        child: const CircularProgressIndicator(strokeWidth: 6),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            if (state.status == PlacesStatus.success && state.places.isEmpty)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.noPlacesFoundText, style: textTheme.bodyLarge),
                    const SizedBox(height: 8),
                    Text(l10n.pleaseTryAgainText),
                    const SizedBox(height: 64),
                  ],
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) => PlaceTile(
                    place: state.places[index],
                  ),
                  itemCount: state.places.length,
                ),
              )
          ],
        );
      },
    );
  }
}
