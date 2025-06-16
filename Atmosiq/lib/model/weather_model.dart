class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final int sunrise;
  final int sunset;
  final double? rainVolume;
  final double? snowVolume;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
    this.rainVolume,
    this.snowVolume,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: (json['main']['temp'] as num).toDouble() - 273.15,
      description: json['weather'][0]['description'],
      humidity: (json['main']['humidity'] as num).toInt(),
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      sunrise: (json['sys']['sunrise'] as int),
      sunset: (json['sys']['sunset'] as int),
      rainVolume: json['rain'] != null ? (json['rain']['1h'] as num?)?.toDouble() ?? 0.0 : 0.0, 
      snowVolume: json['snow'] != null ? (json['snow']['1h'] as num?)?.toDouble() ?? 0.0 : 0.0, 
    );
  }
}
