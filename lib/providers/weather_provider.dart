import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../weather_service.dart';

final weatherProvider = FutureProvider((ref) async {
  return WeatherService().fetchWeather('Rwanda'); // Default to Rwanda
});
