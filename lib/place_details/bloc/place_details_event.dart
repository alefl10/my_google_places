part of 'place_details_bloc.dart';

abstract class PlaceDetailsEvent extends Equatable {
  const PlaceDetailsEvent();
}

class PlaceDetailsDataRequested extends PlaceDetailsEvent {
  const PlaceDetailsDataRequested();

  @override
  List<Object> get props => [];
}
