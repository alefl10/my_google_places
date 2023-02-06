part of 'places_bloc.dart';

abstract class PlacesEvent extends Equatable {
  const PlacesEvent();
}

class PlacesNearbySearched extends PlacesEvent {
  const PlacesNearbySearched({required this.value});

  final String value;

  @override
  List<Object?> get props => [value];
}
