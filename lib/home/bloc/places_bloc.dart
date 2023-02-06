import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator_client/geolocator_client.dart';
import 'package:google_places_models/google_places_models.dart';
import 'package:google_places_repo/google_places_repo.dart';
import 'package:rxdart/rxdart.dart';

part 'places_event.dart';
part 'places_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  PlacesBloc({
    required GooglePlacesRepo googlePlacesRepo,
    required GeolocatorClient geolocatorClient,
  })  : _googlePlacesRepo = googlePlacesRepo,
        _geolocatorClient = geolocatorClient,
        super(const PlacesState()) {
    on<PlacesNearbySearched>(
      _searched,
      transformer: _debounceNearbySearch(const Duration(milliseconds: 300)),
    );
  }
  final GooglePlacesRepo _googlePlacesRepo;
  final GeolocatorClient _geolocatorClient;

  EventTransformer<NearBySearchEvent> _debounceNearbySearch<NearBySearchEvent>(
    Duration duration,
  ) {
    return (events, mapper) => restartable<NearBySearchEvent>()
        .call(events.debounceTime(duration), mapper);
  }

  FutureOr<void> _searched(
    PlacesNearbySearched event,
    Emitter<PlacesState> emit,
  ) async {
    if (event.value.isEmpty) {
      return emit(const PlacesState());
    }
    try {
      emit(state.copyWith(status: PlacesStatus.loading));
      final position = await _geolocatorClient.getCurrentPosition();
      final places = await _googlePlacesRepo.nearbySearch(
        keyword: event.value,
        location: Geometry(
          lat: position.latitude,
          lng: position.longitude,
        ),
      );
      emit(state.copyWith(status: PlacesStatus.success, places: places));
    } on GeolocatorClientLocationDisabledException catch (_) {
      emit(state.copyWith(status: PlacesStatus.locationDisabled));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(state.copyWith(status: PlacesStatus.failure));
    }
  }
}
