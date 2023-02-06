part of 'places_bloc.dart';

enum PlacesStatus {
  initial,
  loading,
  success,
  failure,
  locationDisabled,
}

class PlacesState extends Equatable {
  const PlacesState({
    this.places = const [],
    this.status = PlacesStatus.initial,
  });

  final List<GooglePlace> places;
  final PlacesStatus status;

  @override
  List<Object> get props => [places, status];

  PlacesState copyWith({
    List<GooglePlace>? places,
    PlacesStatus? status,
  }) {
    return PlacesState(
      places: places ?? this.places,
      status: status ?? this.status,
    );
  }
}
