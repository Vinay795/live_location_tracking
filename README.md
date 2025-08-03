# live_location_tracking

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# Show the user current location using Google Maps.
# Continuously update the location in real-time user moves.
# real-time location tracking between (user and search destination) locations.
# Fetch the route between the user current locations and search destination locations.
# Display the distance.
# Display the ETA (estimated time of arrival).
# Display the Calculate an estimated fare based on distance/time.
# Use an appropriate state management solution Bloc.
# Proper handling of location permissions for both Android and iOS.
# fare calculation = baseFare 20 + perKm 15 * totalDistanceMeters (distance / 1000) + perMinute 2 * duration.inMinutes; (accordingly change)
# ETA calculation = totalDistanceMeters  / avgSpeedMetersPerSec (40 * 1000 / 3600)
# Distance calculation = (totalDistance / 1000)