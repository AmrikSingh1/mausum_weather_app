import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/weather_model.dart';

class WeatherService {
  // Replace with your WeatherAPI.com API key
  // Important: Replace this with your actual WeatherAPI.com API key before running the app
  static const String apiKey = '56861d034e1346e5a13180746251903';
  static const String baseUrl = 'https://api.weatherapi.com/v1';

  // Get the current weather based on the city name
  Future<Weather> getWeatherByCity(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/current.json?key=$apiKey&q=$city&aqi=no'),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Mausam Weather App/1.0'
        },
      );

      if (response.statusCode == 200) {
        return _parseWeatherResponse(response.body, city);
      } else {
        final errorJson = jsonDecode(response.body);
        final errorMessage = errorJson['error']?['message'] ?? 'Unknown error';
        throw Exception('Failed to load weather data (${response.statusCode}): $errorMessage');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Get the current weather based on latitude and longitude
  Future<Weather> getWeatherByLocation(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/current.json?key=$apiKey&q=$lat,$lon&aqi=no'),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Mausam Weather App/1.0'
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final cityName = data['location']['name'];
        return _parseWeatherResponse(response.body, cityName);
      } else {
        final errorJson = jsonDecode(response.body);
        final errorMessage = errorJson['error']?['message'] ?? 'Unknown error';
        throw Exception('Failed to load weather data (${response.statusCode}): $errorMessage');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Parse the Weather API response
  Weather _parseWeatherResponse(String responseBody, String cityName) {
    final data = jsonDecode(responseBody);
    final location = data['location'];
    final current = data['current'];
    final condition = current['condition'];

    // Convert time strings to DateTime objects
    final localtime = DateTime.parse(location['localtime'].toString().replaceAll(' ', 'T'));
    // WeatherAPI doesn't provide separate sunrise/sunset times in the current endpoint
    // We'll use the current time to calculate approximate sunrise/sunset
    final now = localtime;
    // Approximating sunrise at 6 AM and sunset at 6 PM of the current day
    final sunrise = DateTime(now.year, now.month, now.day, 6, 0);
    final sunset = DateTime(now.year, now.month, now.day, 18, 0);

    return Weather(
      temperature: current['temp_c'].toDouble(),
      feelsLike: current['feelslike_c'].toDouble(),
      tempMin: current['temp_c'].toDouble() - 2, // Approximate min temp
      tempMax: current['temp_c'].toDouble() + 2, // Approximate max temp
      humidity: current['humidity'] as int,
      pressure: current['pressure_mb'].toInt(),
      windSpeed: current['wind_kph'].toDouble(),
      windDegree: current['wind_degree'] as int,
      main: condition['text'],
      description: condition['text'],
      icon: condition['icon'].toString().replaceAll('//cdn.weatherapi.com/weather/64x64/', ''),
      cityName: cityName,
      visibility: current['vis_km'].toInt() * 1000, // Convert to meters
      sunrise: sunrise,
      sunset: sunset,
      currentTime: localtime,
    );
  }

  // Get forecast based on the city name
  Future<List<ForecastDay>> getForecastByCity(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$city&days=5&aqi=no'),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Mausam Weather App/1.0'
        },
      );

      if (response.statusCode == 200) {
        return _parseForecastResponse(response.body);
      } else {
        final errorJson = jsonDecode(response.body);
        final errorMessage = errorJson['error']?['message'] ?? 'Unknown error';
        throw Exception('Failed to load forecast data (${response.statusCode}): $errorMessage');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Get forecast based on latitude and longitude
  Future<List<ForecastDay>> getForecastByLocation(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$lat,$lon&days=5&aqi=no'),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Mausam Weather App/1.0'
        },
      );

      if (response.statusCode == 200) {
        return _parseForecastResponse(response.body);
      } else {
        final errorJson = jsonDecode(response.body);
        final errorMessage = errorJson['error']?['message'] ?? 'Unknown error';
        throw Exception('Failed to load forecast data (${response.statusCode}): $errorMessage');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Parse the forecast response
  List<ForecastDay> _parseForecastResponse(String responseBody) {
    final data = jsonDecode(responseBody);
    final List<dynamic> forecastList = data['forecast']['forecastday'];
    
    return forecastList.map((day) {
      final date = DateTime.parse(day['date']);
      final dayForecast = day['day'];
      final condition = dayForecast['condition'];
      
      return ForecastDay(
        date: date,
        maxTemp: dayForecast['maxtemp_c'].toDouble(),
        minTemp: dayForecast['mintemp_c'].toDouble(),
        main: condition['text'],
        description: condition['text'],
        icon: condition['icon'].toString().replaceAll('//cdn.weatherapi.com/weather/64x64/', ''),
        windSpeed: dayForecast['maxwind_kph'].toDouble(),
        humidity: dayForecast['avghumidity'].toInt(),
      );
    }).toList();
  }

  // Get hourly forecast based on the city name
  Future<List<HourlyForecast>> getHourlyForecastByCity(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$city&days=1&aqi=no'),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Mausam Weather App/1.0'
        },
      );

      if (response.statusCode == 200) {
        return _parseHourlyForecastResponse(response.body);
      } else {
        final errorJson = jsonDecode(response.body);
        final errorMessage = errorJson['error']?['message'] ?? 'Unknown error';
        throw Exception('Failed to load hourly forecast data (${response.statusCode}): $errorMessage');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Get hourly forecast based on latitude and longitude
  Future<List<HourlyForecast>> getHourlyForecastByLocation(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$lat,$lon&days=1&aqi=no'),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Mausam Weather App/1.0'
        },
      );

      if (response.statusCode == 200) {
        return _parseHourlyForecastResponse(response.body);
      } else {
        final errorJson = jsonDecode(response.body);
        final errorMessage = errorJson['error']?['message'] ?? 'Unknown error';
        throw Exception('Failed to load hourly forecast data (${response.statusCode}): $errorMessage');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Parse the hourly forecast response
  List<HourlyForecast> _parseHourlyForecastResponse(String responseBody) {
    final data = jsonDecode(responseBody);
    final List<dynamic> hourList = data['forecast']['forecastday'][0]['hour'];
    
    // Get all hours instead of only future ones, to ensure we always have data
    // If there are future hours, prioritize those
    final now = DateTime.now();
    var filteredHours = hourList.where((hour) {
      final hourTime = DateTime.parse(hour['time']);
      return hourTime.isAfter(now);
    }).toList();
    
    // If no future hours available, use all hours
    if (filteredHours.isEmpty) {
      filteredHours = hourList;
    }
    
    // Take up to 24 hours (a full day)
    final limitedHours = filteredHours.take(24).toList();
    
    return limitedHours.map((hour) {
      final time = DateTime.parse(hour['time']);
      final condition = hour['condition'];
      
      return HourlyForecast(
        time: time,
        temp: hour['temp_c'].toDouble(),
        icon: condition['icon'].toString().replaceAll('//cdn.weatherapi.com/weather/64x64/', ''),
        description: condition['text'],
        humidity: hour['humidity'] as int,
        feelsLike: hour['feelslike_c'].toDouble(),
        windSpeed: hour['wind_kph'].toDouble(),
        chanceOfRain: hour['chance_of_rain'] as int,
      );
    }).toList();
  }

  // Get the current location (latitude and longitude)
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    } 

    // When we reach here, permissions are granted and we can get the location
    return await Geolocator.getCurrentPosition();
  }

  // Get the city name based on latitude and longitude
  Future<String> getCityNameFromCoordinates(double lat, double lon) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
    Placemark place = placemarks[0];
    return place.locality ?? place.subAdministrativeArea ?? place.administrativeArea ?? 'Unknown Location';
  }
} 