import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? weatherData;
  bool isLoading = false;

  // Remplace par ta clé OpenWeatherMap
  final String apiKey = "6b3b27603f87f692b4865ed962b8c6d2";

  Future<void> fetchWeather(String city) async {
    setState(() => isLoading = true);

    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
        });
      } else {
        setState(() {
          weatherData = {"error": "City not found"};
        });
      }
    } catch (e) {
      setState(() {
        weatherData = {"error": "Something went wrong"};
      });
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather App")),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // Champ recherche
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Enter city name",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      fetchWeather(_controller.text.trim());
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Chargement
            if (isLoading) const CircularProgressIndicator(),

            // Affichage météo
            if (!isLoading && weatherData != null)
              Expanded(
                child: Center(
                  child: weatherData!.containsKey("error")
                      ? Text(weatherData!["error"],
                      style: const TextStyle(
                          fontSize: 18, color: Colors.red))
                      : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${weatherData!["name"]}, ${weatherData!["sys"]["country"]}",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${weatherData!["main"]["temp"]}°C",
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        weatherData!["weather"][0]["main"],
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(height: 20),

                      // Détails
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const Text("Humidity"),
                              Text("${weatherData!["main"]["humidity"]}%"),
                            ],
                          ),
                          Column(
                            children: [
                              const Text("Wind"),
                              Text("${weatherData!["wind"]["speed"]} m/s"),
                            ],
                          ),
                          Column(
                            children: [
                              const Text("Pressure"),
                              Text("${weatherData!["main"]["pressure"]} hPa"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
