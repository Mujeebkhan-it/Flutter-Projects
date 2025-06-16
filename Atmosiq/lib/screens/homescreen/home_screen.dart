import 'package:flutter/material.dart';
import 'package:weather_app/Services/weather_service.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/widgets/weather_card.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _cityController = TextEditingController();
  bool _isLoading = false;
  Weather? _weather;

  void _getWeather() async {
    if (_cityController.text.trim().isEmpty || _isLoading) return;

    //turn off keyboard after pressing the button
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    final weather = await _weatherService.fetchWeather(_cityController.text.trim());

    setState(() {
      _isLoading = false;
    });

    if (weather == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('City not found. Please enter a valid city.')),
      );
      return;
    }

    setState(() {
      _weather = weather;
      _cityController.clear();
    });
  }

  LinearGradient _getBackgroundGradient() {
    if (_weather == null) {
      return const LinearGradient(
        colors: [Colors.grey, Color.fromARGB(255, 109, 191, 232)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }

    String description = _weather!.description.toLowerCase();
    double rainVolume = _weather!.rainVolume ?? 0;
    double snowVolume = _weather!.snowVolume ?? 0;

    if (description.contains('rain') || description.contains('drizzle') ||
        description.contains('thunderstorm') || rainVolume > 0) {
      return const LinearGradient(
        colors: [Colors.black, Colors.blueAccent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (description.contains('snow') || snowVolume > 0) {
      return const LinearGradient(
        colors: [Colors.lightBlueAccent, Colors.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (description.contains('clear') || description.contains('sky') ||
      description.contains('clear sky') ||
        description.contains('sun') || description.contains('overcast cloud')) {
      return const LinearGradient(
        colors: [Colors.orangeAccent, Colors.blueAccent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (description.contains('haze') || description.contains('mist') ||
        description.contains('fog') || description.contains('smoke')) {
      return const LinearGradient(
        colors: [Color.fromARGB(255, 100, 161, 232), Color.fromARGB(255, 192, 215, 255)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [Color.fromARGB(255, 6, 119, 164), Color.fromARGB(255, 7, 248, 63)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(gradient: _getBackgroundGradient()),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 25),
                const Text(
                  "Weather App",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: _cityController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter city name",
                    hintStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: const Color.fromARGB(90, 255, 255, 255),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _getWeather,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(155, 255, 255, 255),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                      : const Text("Get Weather", style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 20),
                if (_weather != null) WeatherCard(weather: _weather!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
