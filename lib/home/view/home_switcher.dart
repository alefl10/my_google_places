import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_google_places/home/home.dart';
import 'package:my_google_places/l10n/l10n.dart';
import 'package:my_google_places/permission/permission.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeBodySwitcher extends StatelessWidget {
  const HomeBodySwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<PermissionBloc, PermissionState>(
      listenWhen: (pre, cur) =>
          pre.locationPermissionStatus != cur.locationPermissionStatus ||
          pre.didOpenSettings != cur.didOpenSettings,
      listener: (context, state) {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        if (state.didOpenSettings == false) {
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text(l10n.openSettingsErrorText)),
          );
        } else if (!state.locationPermissionWasGranted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text(l10n.locationPermissionNotGrantedText)),
          );
        }
      },
      buildWhen: (pre, cur) =>
          pre.locationPermissionStatus != cur.locationPermissionStatus,
      builder: (context, state) {
        switch (state.locationPermissionStatus) {
          case PermissionStatus.granted:
          case PermissionStatus.limited:
            return const HomeView();
          case PermissionStatus.restricted:
          case PermissionStatus.denied:
          case PermissionStatus.permanentlyDenied:
            return const LocationNotAvailableBody();
          case null:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
