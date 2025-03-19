import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/weather_model.dart';
import '../utils/weather_utils.dart';
import '../themes/app_theme.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;
  final VoidCallback onTap;
  final bool showDetails;

  const WeatherCard({
    super.key,
    required this.weather,
    required this.onTap,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 8,
        shadowColor: Colors.black26,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: WeatherUtils.getBackgroundGradient(
              weather.currentTime,
              weather.main,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // City name with location icon
                          Row(
                            children: [
                              const Icon(Icons.location_on, 
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  weather.cityName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ).animate().fadeIn(delay: 200.ms),
                          
                          const SizedBox(height: 4),
                          
                          // Date and time
                          Text(
                            '${WeatherUtils.formatDate(weather.currentTime)} | ${WeatherUtils.formatTime(weather.currentTime)}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ).animate().fadeIn(delay: 300.ms),
                        ],
                      ),
                    ),
                    
                    // Temperature in large format
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${weather.temperature.round()}°',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ).animate().fadeIn(delay: 400.ms).moveX(begin: 20, end: 0, delay: 400.ms, duration: 400.ms),
                        
                        Text(
                          weather.description,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ).animate().fadeIn(delay: 500.ms),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Weather animation
                Center(
                  child: SizedBox(
                    height: 140,
                    width: 140,
                    child: Lottie.asset(
                      WeatherUtils.getWeatherIcon(weather.icon),
                      animate: true,
                    ),
                  ).animate().fadeIn(delay: 600.ms).scale(delay: 600.ms, duration: 500.ms),
                ),
                
                if (showDetails) ...[
                  const SizedBox(height: 20),
                  
                  // Weather details in a row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildWeatherDetail(
                        Icons.air_rounded,
                        'Wind',
                        WeatherUtils.formatWind(weather.windSpeed, weather.windDegree),
                      ),
                      _buildWeatherDetail(
                        Icons.water_drop_outlined,
                        'Humidity',
                        '${weather.humidity}%',
                      ),
                      _buildWeatherDetail(
                        Icons.thermostat_outlined,
                        'Feels Like',
                        '${weather.feelsLike.round()}°',
                      ),
                    ],
                  ).animate().fadeIn(delay: 700.ms),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class ForecastCard extends StatelessWidget {
  final ForecastDay forecast;
  
  const ForecastCard({
    super.key,
    required this.forecast,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Day of week
            SizedBox(
              width: 70,
              child: Text(
                WeatherUtils.formatDate(forecast.date),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Weather icon
            SizedBox(
              width: 50,
              height: 50,
              child: Lottie.asset(
                WeatherUtils.getWeatherIcon(forecast.icon),
                animate: true,
              ),
            ),
            
            // Weather description
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  forecast.description,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            
            // Temperature range
            Row(
              children: [
                Text(
                  '${forecast.maxTemp.round()}°',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${forecast.minTemp.round()}°',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 100));
  }
}

class HourlyForecastItem extends StatelessWidget {
  final HourlyForecast forecast;
  final bool isSelected;
  
  const HourlyForecastItem({
    super.key,
    required this.forecast,
    this.isSelected = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected 
            ? AppTheme.primary.withOpacity(0.3) 
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected 
              ? AppTheme.primary 
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            WeatherUtils.formatHour(forecast.time),
            style: TextStyle(
              color: isSelected 
                  ? AppTheme.primary 
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            width: 40,
            child: Lottie.asset(
              WeatherUtils.getWeatherIcon(forecast.icon),
              animate: true,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${forecast.temp.round()}°',
            style: TextStyle(
              color: isSelected 
                  ? AppTheme.primary 
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
} 