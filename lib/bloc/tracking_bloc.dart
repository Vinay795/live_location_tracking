import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'tracking_event.dart';
import 'tracking_state.dart';

const String googleAPIKey = 'AIzaSyCNg3wM-49X3d4x8P25j_Vv2TV31E-LuHQ';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  StreamSubscription<Position>? _positionStream;

  TrackingBloc() : super(const TrackingState()) {
    on<StartTracking>(_onStartTracking);
    on<SearchDestination>(_onSearchDestination);
    on<UpdateCurrentLocation>(_onUpdateCurrentLocation);
  }

  Future<void> _onStartTracking(
      StartTracking event, Emitter<TrackingState> emit) async {
    final permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever) {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final start = LatLng(position.latitude, position.longitude);
      final startMarker = Marker(
        markerId: const MarkerId('start'),
        position: start,
        infoWindow: const InfoWindow(title: 'Start'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );

      emit(state.copyWith(
        startLocation: start,
        markers: {startMarker},
        loading: false,
      ));

      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(distanceFilter: 10),
      ).listen((position) {
        add(UpdateCurrentLocation(position.latitude, position.longitude));
      });
    }
  }

  void _onUpdateCurrentLocation(
      UpdateCurrentLocation event, Emitter<TrackingState> emit) {
    final current = LatLng(event.latitude, event.longitude);
    final newMarker = Marker(
      markerId: const MarkerId('current'),
      position: current,
      infoWindow: const InfoWindow(title: 'You are here'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );

    final markers = Set<Marker>.from(state.markers)
      ..removeWhere((m) => m.markerId == const MarkerId('current'))
      ..add(newMarker);

    emit(state.copyWith(currentLocation: current, markers: markers));
  }

  Future<void> _onSearchDestination(
      SearchDestination event, Emitter<TrackingState> emit) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=${event.query}&inputtype=textquery&fields=geometry&key=$googleAPIKey'));

    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      final location = data['candidates'][0]['geometry']['location'];
      final destination = LatLng(location['lat'], location['lng']);

      final newMarkers = Set<Marker>.from(state.markers)
        ..removeWhere((m) => m.markerId == const MarkerId('destination'))
        ..add(Marker(
          markerId: const MarkerId('destination'),
          position: destination,
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ));

      final result = await PolylinePoints().getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(state.startLocation!.latitude, state.startLocation!.longitude),
        PointLatLng(destination.latitude, destination.longitude),
        travelMode: TravelMode.driving,
      );

      List<LatLng> route = result.points
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();

      double distance = 0;
      for (int i = 0; i < route.length - 1; i++) {
        distance += Geolocator.distanceBetween(
          route[i].latitude,
          route[i].longitude,
          route[i + 1].latitude,
          route[i + 1].longitude,
        );
      }

      double speed = 40 * 1000 / 3600;
      Duration duration = Duration(seconds: (distance / speed).round());

      double fare = 20 + 15 * (distance / 1000) + 2 * duration.inMinutes;

      emit(state.copyWith(
        destination: destination,
        markers: newMarkers,
        polylines: {
          Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.blue,
            width: 5,
            points: route,
          ),
        },
        totalDistance: distance,
        estimatedDuration: duration,
        fare: fare,
      ));
    }
  }

  @override
  Future<void> close() {
    _positionStream?.cancel();
    return super.close();
  }
}
