import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_location_tracking/bloc/tracking_bloc.dart';
import 'package:live_location_tracking/bloc/tracking_event.dart';
import 'package:live_location_tracking/bloc/tracking_state.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Real-time Tracking')),
      body: BlocBuilder<TrackingBloc, TrackingState>(
        builder: (context, state) {
          if (state.loading || state.startLocation == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition:
                CameraPosition(target: state.startLocation!, zoom: 14),
                markers: state.markers,
                polylines: state.polylines,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: TextField(
                    controller: controller,
                    onSubmitted: (value) => context
                        .read<TrackingBloc>()
                        .add(SearchDestination(value)),
                    decoration: InputDecoration(
                      hintText: 'Enter destination',
                      contentPadding: const EdgeInsets.all(12),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () => context
                            .read<TrackingBloc>()
                            .add(SearchDestination(controller.text)),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          'Distance: ${(state.totalDistance / 1000).toStringAsFixed(2)} km'),
                      const SizedBox(height: 5),
                      Text('ETA: ${state.estimatedDuration.inMinutes} min'),
                      const SizedBox(height: 5),
                      Text('Fare: ₹${state.fare.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
