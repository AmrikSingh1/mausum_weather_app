import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';
import '../utils/weather_utils.dart';
import '../themes/app_theme.dart';
import 'about_animations_screen.dart';
import 'package:lottie/lottie.dart';
import '../models/weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSearchDialog(BuildContext context, WeatherProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Location'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Enter city name',
            prefixIcon: Icon(Icons.search),
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              provider.fetchWeatherByCity(value);
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_searchController.text.isNotEmpty) {
                provider.fetchWeatherByCity(_searchController.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mausam Weather'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          Consumer<WeatherProvider>(
            builder: (context, provider, _) => IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _showSearchDialog(context, provider),
            ),
          ),
          Consumer<WeatherProvider>(
            builder: (context, provider, _) => IconButton(
              icon: Icon(provider.useCelsius ? Icons.thermostat : Icons.thermostat_auto),
              onPressed: () => provider.toggleTemperatureUnit(),
              tooltip: 'Toggle temperature unit',
            ),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('About Animations'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutAnimationsScreen(),
                  ),
                ),
              ),
              const PopupMenuItem(
                value: 'theme',
                child: Text('Toggle Theme'),
              ),
            ],
            onSelected: (value) {
              if (value == 'theme') {
                final provider = Provider.of<WeatherProvider>(context, listen: false);
                provider.setThemeMode(
                  provider.themeMode == ThemeMode.dark 
                      ? ThemeMode.light 
                      : ThemeMode.dark
                );
              }
            },
          ),
        ],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, _) {
          if (weatherProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (weatherProvider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${weatherProvider.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => weatherProvider.fetchWeatherByLocation(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          } else if (weatherProvider.currentWeather == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/logo.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No weather data available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      weatherProvider.fetchWeatherByLocation();
                    },
                    child: const Text('Get Weather for My Location'),
                  ),
                ],
              ),
            );
          } else {
            // When we have weather data
            return RefreshIndicator(
              onRefresh: () async {
                if (weatherProvider.selectedCity.isNotEmpty) {
                  await weatherProvider.fetchWeatherByCity(weatherProvider.selectedCity);
                } else {
                  await weatherProvider.fetchWeatherByLocation();
                }
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WeatherCard(
                      weather: weatherProvider.currentWeather!,
                      onTap: () {},
                    ),
                    const SizedBox(height: 20),
                    
                    // Daily forecast section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '7-Day Forecast',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 120,
                              child: weatherProvider.forecastDays.isEmpty
                                  ? const Center(child: Text('No forecast data available'))
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: weatherProvider.forecastDays.length,
                                      itemBuilder: (context, index) {
                                        final forecast = weatherProvider.forecastDays[index];
                                        return _buildForecastItem(context, forecast, weatherProvider);
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Hourly forecast section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Hourly Forecast',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${weatherProvider.hourlyForecast.length} hours',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 140,
                              child: weatherProvider.hourlyForecast.isEmpty
                                  ? const Center(child: Text('No hourly data available'))
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: weatherProvider.hourlyForecast.length,
                                      itemBuilder: (context, index) {
                                        final hourly = weatherProvider.hourlyForecast[index];
                                        return _buildHourlyItem(context, hourly, weatherProvider);
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Credit footer
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'Made by AMRIK SINGH',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Provider.of<WeatherProvider>(context, listen: false).fetchWeatherByLocation(),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.my_location),
      ),
    );
  }
  
  Widget _buildForecastItem(BuildContext context, ForecastDay forecast, WeatherProvider provider) {
    final temp = provider.getTemperatureWithUnit(forecast.maxTemp);
    final dayName = WeatherUtils.getDayName(forecast.date);
    
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dayName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 40,
            width: 40,
            child: Lottie.asset(WeatherUtils.getWeatherIcon(forecast.icon)),
          ),
          const SizedBox(height: 4),
          Text(
            temp,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHourlyItem(BuildContext context, HourlyForecast hourly, WeatherProvider provider) {
    final temp = provider.getTemperatureWithUnit(hourly.temp);
    final time = WeatherUtils.formatHour(hourly.time);
    final isNow = DateTime.now().difference(hourly.time).inHours.abs() < 1;
    
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isNow ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3) : null,
        borderRadius: BorderRadius.circular(12),
        border: isNow 
            ? Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5)
            : null,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isNow ? 'Now' : time,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isNow ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            width: 40,
            child: Lottie.asset(WeatherUtils.getWeatherIcon(hourly.icon)),
          ),
          const SizedBox(height: 8),
          Text(
            temp,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isNow ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.water_drop,
                size: 12,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
              ),
              Text(
                '${hourly.chanceOfRain}%',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 