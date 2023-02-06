part of 'place_details_bloc.dart';

enum PlaceDetailsStatus { initial, loading, success, error }

class PlaceDetailsState extends Equatable {
  const PlaceDetailsState({
    required this.place,
    this.status = PlaceDetailsStatus.initial,
  });

  final GooglePlace place;
  final PlaceDetailsStatus status;

  @override
  List<Object> get props => [place, status];

  PlaceDetailsState copyWith({
    GooglePlace? place,
    PlaceDetailsStatus? status,
  }) {
    return PlaceDetailsState(
      place: place ?? this.place,
      status: status ?? this.status,
    );
  }
}
