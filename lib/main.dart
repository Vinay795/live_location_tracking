import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_location_tracking/bloc/tracking_bloc.dart';
import 'package:live_location_tracking/bloc/tracking_event.dart';
import 'package:live_location_tracking/tracking_page.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => TrackingBloc()..add(StartTracking()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TrackingPage(), // ✅ Use your page widget here
      debugShowCheckedModeBanner: false,
    );
  }
}

