import 'package:equatable/equatable.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object?> get props => [];
}

class StartTracking extends TrackingEvent {}

class SearchDestination extends TrackingEvent {
  final String query;

  const SearchDestination(this.query);

  @override
  List<Object?> get props => [query];
}

class UpdateCurrentLocation extends TrackingEvent {
  final double latitude;
  final double longitude;

  const UpdateCurrentLocation(this.latitude, this.longitude);

  @override
  List<Object?> get props => [latitude, longitude];
}
