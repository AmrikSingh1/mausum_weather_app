class Weather {
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int windDegree;
  final String main;
  final String description;
  final String icon;
  final String cityName;
  final int visibility;
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime currentTime;

  Weather({
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDegree,
    required this.main,
    required this.description,
    required this.icon,
    required this.cityName,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
    required this.currentTime,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      pressure: json['main']['pressure'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      windDegree: json['wind']['deg'] as int,
      main: json['weather'][0]['main'] as String,
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
      cityName: json['name'] as String,
      visibility: json['visibility'] as int,
      sunrise: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000),
      currentTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
    );
  }
}

class ForecastDay {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String main;
  final String description;
  final String icon;
  final double windSpeed;
  final int humidity;

  ForecastDay({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.main,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.humidity,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      maxTemp: (json['temp']['max'] as num).toDouble(),
      minTemp: (json['temp']['min'] as num).toDouble(),
      main: json['weather'][0]['main'] as String,
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
      windSpeed: (json['speed'] as num).toDouble(),
      humidity: json['humidity'] as int,
    );
  }
}

class HourlyForecast {
  final DateTime time;
  final double temp;
  final String icon;
  final String description;
  final int humidity;
  final double feelsLike;
  final double windSpeed;
  final int chanceOfRain;

  HourlyForecast({
    required this.time,
    required this.temp,
    required this.icon,
    required this.description,
    required this.humidity,
    required this.feelsLike,
    required this.windSpeed,
    required this.chanceOfRain,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temp: (json['temp'] as num).toDouble(),
      icon: json['weather'][0]['icon'] as String,
      description: json['weather'][0]['description'] as String,
      humidity: 0, // Default values, will be replaced with real parser
      feelsLike: 0,
      windSpeed: 0,
      chanceOfRain: 0,
    );
  }
} 