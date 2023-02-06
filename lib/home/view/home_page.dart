import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator_client/geolocator_client.dart';
import 'package:google_places_repo/google_places_repo.dart';
import 'package:my_google_places/home/home.dart';
import 'package:my_google_places/l10n/l10n.dart';
import 'package:my_google_places/permission/permission.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<PermissionBloc>().add(const PermissionLocationRequested());
    final l10n = context.l10n;

    return BlocProvider(
      create: (context) => PlacesBloc(
        googlePlacesRepo: context.read<GooglePlacesRepo>(),
        geolocatorClient: context.read<GeolocatorClient>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.homeAppBarTitle),
          centerTitle: true,
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: HomeBodySwitcher(),
        ),
      ),
    );
  }
}
