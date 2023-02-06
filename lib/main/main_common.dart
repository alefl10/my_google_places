import 'package:flutter/material.dart';
import 'package:geolocator_client/geolocator_client.dart';
import 'package:google_places_client/google_places_client.dart';
import 'package:google_places_repo/google_places_repo.dart';
import 'package:my_google_places/app/app.dart';
import 'package:my_google_places/main/configs/configs.dart';
import 'package:permission_client/permission_client.dart';

Future<Widget> mainCommon({required AppEnvironment appEnvironment}) async {
  await ConfigReader.initialize();

  // Clients Initialization
  final googlePlacesClient = GooglePlacesClient(
    apiKey: ConfigReader.getGoogleMapsApiKey(appEnvironment.name),
  );
  const permissionClient = PermissionClient();
  const geolocatorClient = GeolocatorClient();

  // Repositories Initialization
  final googlePlacesRepo = GooglePlacesRepo(client: googlePlacesClient);

  return App(
    permissionClient: permissionClient,
    geolocatorClient: geolocatorClient,
    googlePlacesRepo: googlePlacesRepo,
  );
}
