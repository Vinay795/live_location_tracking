import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingState extends Equatable {
  final LatLng? startLocation;
  final LatLng? currentLocation;
  final LatLng? destination;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final double totalDistance;
  final Duration estimatedDuration;
  final double fare;
  final bool loading;

  const TrackingState({
    this.startLocation,
    this.currentLocation,
    this.destination,
    this.markers = const {},
    this.polylines = const {},
    this.totalDistance = 0.0,
    this.estimatedDuration = Duration.zero,
    this.fare = 0.0,
    this.loading = true,
  });

  TrackingState copyWith({
    LatLng? startLocation,
    LatLng? currentLocation,
    LatLng? destination,
    Set<Marker>? markers,
    Set<Polyline>? polylines,
    double? totalDistance,
    Duration? estimatedDuration,
    double? fare,
    bool? loading,
  }) {
    return TrackingState(
      startLocation: startLocation ?? this.startLocation,
      currentLocation: currentLocation ?? this.currentLocation,
      destination: destination ?? this.destination,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      totalDistance: totalDistance ?? this.totalDistance,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      fare: fare ?? this.fare,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [
    startLocation,
    currentLocation,
    destination,
    markers,
    polylines,
    totalDistance,
    estimatedDuration,
    fare,
    loading,
  ];
}
