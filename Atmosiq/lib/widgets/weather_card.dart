import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:lottie/lottie.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;
  const WeatherCard({super.key, required this.weather});

  String formatTime(int timeStamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    return DateFormat("hh:mm a").format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(108, 255, 255, 255),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // **Weather Animation**
              Lottie.asset(
                weather.description.contains('rain') || weather.rainVolume! > 0
                    ? 'assets/rain.json'
                    : weather.description.contains('snow') || weather.snowVolume! > 0
                        ? 'assets/snowfall.json'
                        : weather.description.contains('clear')
                            ? 'assets/sunny.json'
                            : 'assets/cloudy.json',
                height: 150,
                width: 150,
              ),

              // **City Name**
              Text(
                weather.cityName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 10),

              // **Temperature**
              Text(
                "${weather.temperature.toStringAsFixed(1)}°C",  // Display temperature with one decimal
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 10),

              // **Weather Description**
              Text(
                weather.description,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 20),

              // **Humidity & Wind Speed**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Humidity: ${weather.humidity}%",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    "Wind: ${weather.windSpeed} m/s",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // **Rain & Snow Volume**
              if (weather.rainVolume! > 0 || weather.snowVolume! > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (weather.rainVolume! > 0)
                      Column(
                        children: [
                          const Icon(Icons.grain, color: Colors.blue),
                          Text(
                            "Rain",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            "${weather.rainVolume} mm",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    if (weather.snowVolume! > 0)
                      Column(
                        children: [
                          const Icon(Icons.ac_unit, color: Colors.white),
                          Text(
                            "Snow",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            "${weather.snowVolume} mm",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                  ],
                ),

              const SizedBox(height: 20),

              // **Sunrise & Sunset Time**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.wb_sunny_outlined, color: Colors.orange),
                      Text(
                        "Sunrise",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        formatTime(weather.sunrise),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Icon(Icons.nights_stay_outlined, color: Colors.purple),
                      Text(
                        "Sunset",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        formatTime(weather.sunset),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
