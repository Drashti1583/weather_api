import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../services/models/weather.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    if (weatherProvider.lastSearchedCity != null) {
      _cityController.text = weatherProvider.lastSearchedCity!;
    }

    return Scaffold(
      appBar: AppBar(title: Text('Weather App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'Enter city name'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final city = _cityController.text;
                if (city.isNotEmpty) {
                  weatherProvider.fetchWeather(city);
                }
              },
              child: Text('Get Weather'),
            ),
            SizedBox(height: 16.0),
            Consumer<WeatherProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return CircularProgressIndicator();
                } else if (provider.weather != null) {
                  return Column(
                    children: [
                      WeatherDetails(provider.weather!),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          if (provider.lastSearchedCity != null) {
                            provider.fetchWeather(provider.lastSearchedCity!);
                          }
                        },
                        child: Text('Refresh'),
                      ),
                    ],
                  );
                } else if (provider.error != null) {
                  return Text(provider.error!);
                } else {
                  return Text('Enter a city name to get weather information');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherDetails extends StatelessWidget {
  final Weather weather;

  WeatherDetails(this.weather);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('City: ${weather.cityName}'),
        Text('Temperature: ${weather.temperature} °C'),
        Text('Condition: ${weather.weatherCondition}'),
        Text('Humidity: ${weather.humidity}%'),
        Text('Wind Speed: ${weather.windSpeed} m/s'),
        Image.network('https://openweathermap.org/img/w/${weather.icon}.png'),
      ],
    );
  }
}
