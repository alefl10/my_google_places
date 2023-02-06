import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_places_models/google_places_models.dart';
import 'package:google_places_repo/google_places_repo.dart';

part 'place_details_event.dart';
part 'place_details_state.dart';

class PlaceDetailsBloc extends Bloc<PlaceDetailsEvent, PlaceDetailsState> {
  PlaceDetailsBloc({
    required GooglePlacesRepo googlePlacesRepo,
    required GooglePlace place,
  })  : _googlePlacesRepo = googlePlacesRepo,
        super(PlaceDetailsState(place: place)) {
    on<PlaceDetailsDataRequested>(_dataRequested);
  }

  final GooglePlacesRepo _googlePlacesRepo;

  FutureOr<void> _dataRequested(
    PlaceDetailsDataRequested event,
    Emitter<PlaceDetailsState> emit,
  ) async {
    emit(state.copyWith(status: PlaceDetailsStatus.loading));
    try {
      final place = await _googlePlacesRepo.getPlaceDetails(
        placeId: state.place.placeId!,
      );
      emit(
        state.copyWith(
          place: place,
          status: PlaceDetailsStatus.success,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(state.copyWith(status: PlaceDetailsStatus.error));
    }
  }
}
