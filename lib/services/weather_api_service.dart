import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApiService {
  static const String apiKey = '95540f75c5a0eac4de7ce5cb4aa7d30a';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final response = await http.get(Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric'));

    // Print response details for debugging
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data: ${response.body}');
    }
  }
}

void main() async {
  final service = WeatherApiService();
  try {
    final weatherData = await service.fetchWeather('London');
    print(weatherData);
  } catch (e) {
    print(e);
  }
}
