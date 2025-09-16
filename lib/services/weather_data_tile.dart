import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class WeatherService {
  final Stream apikey = '6b3b27603f87f692b4865ed962b8c6d2';

  Future<Map<String, dynamic>> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse(
        'http://api.openweathermap.org/data/2.0/weather?q=$cityName&appid=$apiKey&units=metric',
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to  Load data');
    }
  }

  Future<Map<String, dynamic>> fetchWeather(String cityName) async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    double lat = position.latitude, lon = position.longitude;
    final response = await http.get(
      Uri.parse(
        'http://api.openweathermap.org/data/2.0/weather?lat=$lat&lon=$lon&$appid=$apiKey&units=metric',
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to  Load data');
    }
  }
}
