import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_client/geolocator_client.dart';
import 'package:google_places_repo/google_places_repo.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_google_places/l10n/l10n.dart';
import 'package:my_google_places/permission/permission.dart';
import 'package:permission_client/permission_client.dart';
import 'package:permission_handler/permission_handler.dart';

class MockPermissionClient extends Mock implements PermissionClient {}

class MockGeolocatorClient extends Mock implements GeolocatorClient {}

class MockGooglePlacesRepo extends Mock implements GooglePlacesRepo {
  @override
  String getPlacePhotoUrl({
    required String photoReference,
    int? maxWidth,
    int? minWidth,
  }) {
    return 'url';
  }
}

class MockPermissionBloc extends MockBloc<PermissionEvent, PermissionState>
    implements PermissionBloc {
  @override
  PermissionState get state => const PermissionState(
        locationPermissionStatus: PermissionStatus.granted,
      );
}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    PermissionClient? permissionClient,
    GeolocatorClient? geolocatorClient,
    GooglePlacesRepo? googlePlacesRepo,
    PermissionBloc? permissionBloc,
  }) {
    return pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: permissionClient ?? MockPermissionClient(),
          ),
          RepositoryProvider.value(
            value: geolocatorClient ?? MockGeolocatorClient(),
          ),
          RepositoryProvider.value(
            value: googlePlacesRepo ?? MockGooglePlacesRepo(),
          ),
        ],
        child: BlocProvider.value(
          value: permissionBloc ?? MockPermissionBloc(),
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: widget,
          ),
        ),
      ),
    );
  }
}
