import 'dart:convert';
import 'package:weather_app/model/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = "8efa09ab30b3077df42628d30bd2f34e";

  Future<Weather?> fetchWeather(String cityName) async {
    try {
      final url =
          "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey";
          
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        print('Raw response: ${response.body}');
        return Weather.fromJson(json.decode(response.body));
      } else {
        print('Error: City not found');
        return null; // Return null when city is not found
      }
    } catch (e) {
      print('Error: $e');
      return null; // Return null on network error
    }
  }
}
