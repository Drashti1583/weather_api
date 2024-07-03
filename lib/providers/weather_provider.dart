import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/models/weather.dart';
import '../services/weather_api_service.dart';


class WeatherProvider with ChangeNotifier {
  Weather? _weather;
  bool _isLoading = false;
  String? _error;
  String? _lastSearchedCity;

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get lastSearchedCity => _lastSearchedCity;

  final WeatherApiService _apiService = WeatherApiService();

  WeatherProvider() {
    _loadLastSearchedCity();
  }

  Future<void> fetchWeather(String city) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final weatherData = await _apiService.fetchWeather(city);
      _weather = Weather.fromJson(weatherData);
      _lastSearchedCity = city;
      _saveLastSearchedCity(city);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadLastSearchedCity() async {
    final prefs = await SharedPreferences.getInstance();
    _lastSearchedCity = prefs.getString('lastSearchedCity');
    if (_lastSearchedCity != null) {
      await fetchWeather(_lastSearchedCity!);
    }
  }

  Future<void> _saveLastSearchedCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lastSearchedCity', city);
  }
}
