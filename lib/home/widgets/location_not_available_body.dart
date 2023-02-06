import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_google_places/l10n/l10n.dart';
import 'package:my_google_places/permission/permission.dart';

class LocationNotAvailableBody extends StatelessWidget {
  const LocationNotAvailableBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(l10n.locationNotAvailable, style: textTheme.bodyLarge),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blueAccent,
                ),
                onPressed: () {
                  context
                      .read<PermissionBloc>()
                      .add(const PermissionSettingsOpened());
                },
                child: Text(l10n.openSettingsText),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<PermissionBloc>()
                      .add(const PermissionLocationRequested());
                },
                child: Text(l10n.getLocationText),
              ),
            ],
          )
        ],
      ),
    );
  }
}
