import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../themes/app_theme.dart';

class WeatherUtils {
  // Format the date
  static String formatDate(DateTime date, {bool showDay = true}) {
    if (showDay) {
      return DateFormat('EEE, MMM d').format(date);
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  // Format the time
  static String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  // Format the hour only
  static String formatHour(DateTime time) {
    return DateFormat('h a').format(time);
  }

  // Get the weather icon name based on WeatherAPI.com icon code
  static String getWeatherIcon(String iconPath) {
    // WeatherAPI icon format: day/night + condition code (e.g., 'day/113.png' for a sunny day)
    final isDay = iconPath.contains('day');
    
    // Extract condition code from path
    final regex = RegExp(r'(\d+)\.png$');
    final match = regex.firstMatch(iconPath);
    final conditionCode = match?.group(1) ?? '113'; // Default to sunny condition if no match
    
    switch (conditionCode) {
      case '113': // Sunny / Clear
        return isDay ? 'assets/animations/clear-day.json' : 'assets/animations/clear-day.json'; // Fallback to clear-day.json for night
      
      case '116': // Partly cloudy
        return isDay ? 'assets/animations/partly-cloudy-night.json' : 'assets/animations/partly-cloudy-night.json'; // Use partly-cloudy-night.json for both day and night
      
      case '119': // Cloudy
      case '122': // Overcast
        return 'assets/animations/cloudy.json';
      
      case '143': // Mist
      case '248': // Fog
      case '260': // Freezing fog
        return 'assets/animations/mist.json';
      
      case '176': // Patchy rain
      case '185': // Patchy freezing drizzle
      case '263': // Patchy light drizzle
      case '266': // Light drizzle
      case '281': // Freezing drizzle
      case '284': // Heavy freezing drizzle
      case '293': // Patchy light rain
      case '296': // Light rain
        return isDay ? 'assets/animations/rain-day.json' : 'assets/animations/rain.json'; // Use rain.json for night
      
      case '299': // Moderate rain
      case '302': // Heavy rain
      case '305': // Heavy rain at times
      case '308': // Heavy rain
      case '311': // Light freezing rain
      case '314': // Moderate or heavy freezing rain
        return 'assets/animations/rain.json';
      
      case '200': // Thundery outbreaks
      case '386': // Patchy light rain with thunder
      case '389': // Moderate or heavy rain with thunder
      case '392': // Patchy light snow with thunder
      case '395': // Moderate or heavy snow with thunder
        return 'assets/animations/thunderstorm.json';
      
      case '179': // Patchy snow
      case '182': // Patchy sleet
      case '227': // Blowing snow
      case '230': // Blizzard
      case '323': // Patchy light snow
      case '326': // Light snow
      case '329': // Patchy moderate snow
      case '332': // Moderate snow
      case '335': // Patchy heavy snow
      case '338': // Heavy snow
      case '350': // Ice pellets
      case '362': // Light sleet
      case '365': // Moderate or heavy sleet
      case '368': // Light snow showers
      case '371': // Moderate or heavy snow showers
      case '374': // Light showers of ice pellets
      case '377': // Moderate or heavy showers of ice pellets
        return 'assets/animations/rain.json'; // Use rain.json as fallback for snow
      
      default:
        return 'assets/animations/clear-day.json'; // Default to clear-day.json
    }
  }

  // Get the background gradient based on the time of day and weather condition
  static LinearGradient getBackgroundGradient(DateTime time, String weatherMain) {
    final hour = time.hour;
    final isDay = hour >= 6 && hour < 18;
    final weatherCondition = weatherMain.toLowerCase();
    
    // Morning: 6-11, Afternoon: 12-17, Evening: 18-21, Night: 22-5
    if (weatherCondition.contains('rain') || 
        weatherCondition.contains('drizzle') ||
        weatherCondition.contains('sleet')) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF637E90),
          Color(0xFF2C3E50),
        ],
      );
    } else if (weatherCondition.contains('thunder') || 
               weatherCondition.contains('lightning')) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF4A6572),
          Color(0xFF232F34),
        ],
      );
    } else if (weatherCondition.contains('snow') || 
               weatherCondition.contains('ice') || 
               weatherCondition.contains('blizzard')) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFB8D5E1),
          Color(0xFF7798AB),
        ],
      );
    } else if (weatherCondition.contains('sunny') || 
               weatherCondition.contains('clear')) {
      if (hour >= 6 && hour < 10) { // Morning
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFA726),  // Morning orange
            Color(0xFFFF7043),  // Deeper orange
          ],
        );
      } else if (hour >= 10 && hour < 16) { // Midday
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2196F3),  // Sky blue
            Color(0xFF03A9F4),  // Light blue
          ],
        );
      } else if (hour >= 16 && hour < 19) { // Evening/Sunset
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFF9800),  // Orange
            Color(0xFFFF5722),  // Deep orange
          ],
        );
      } else { // Night
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3F51B5),  // Dark blue
            Color(0xFF1A237E),  // Deeper blue
          ],
        );
      }
    } else { // Cloudy, overcast, mist, or default
      if (isDay) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF90CAF9),
            Color(0xFF42A5F5),
          ],
        );
      } else {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF546E7A),
            Color(0xFF263238),
          ],
        );
      }
    }
  }

  // Get a color associated with the weather condition
  static Color getWeatherColor(String weatherMain) {
    final condition = weatherMain.toLowerCase();
    
    if (condition.contains('sunny') || condition.contains('clear')) {
      return AppTheme.warmYellow;
    } else if (condition.contains('cloud') || condition.contains('overcast')) {
      return AppTheme.coolBlue;
    } else if (condition.contains('rain') || condition.contains('drizzle') || condition.contains('sleet')) {
      return AppTheme.peacockBlue;
    } else if (condition.contains('thunder') || condition.contains('lightning')) {
      return AppTheme.royalPurple;
    } else if (condition.contains('snow') || condition.contains('ice') || condition.contains('blizzard')) {
      return AppTheme.textLight;
    } else if (condition.contains('mist') || 
               condition.contains('fog') || 
               condition.contains('haze') || 
               condition.contains('dust')) {
      return AppTheme.textDark;
    } else {
      return AppTheme.primary;
    }
  }

  // Format the wind speed with direction
  static String formatWind(double speed, int degree) {
    final directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((degree / 45) % 8).round();
    return '${speed.toStringAsFixed(1)} km/h ${directions[index]}';
  }

  // Get AQI (Air Quality Index) color
  static Color getAqiColor(int aqi) {
    switch (aqi) {
      case 1: // Good
        return Colors.green;
      case 2: // Fair
        return Colors.yellow;
      case 3: // Moderate
        return Colors.orange;
      case 4: // Poor
        return Colors.red;
      case 5: // Very Poor
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Get AQI text
  static String getAqiText(int aqi) {
    switch (aqi) {
      case 1:
        return 'Good';
      case 2:
        return 'Fair';
      case 3:
        return 'Moderate';
      case 4:
        return 'Poor';
      case 5:
        return 'Very Poor';
      default:
        return 'Unknown';
    }
  }
} 