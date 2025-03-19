import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';
import '../utils/weather_utils.dart';
import '../themes/app_theme.dart';
import 'about_animations_screen.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchExpanded = false;
  int _selectedHourIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        final weather = weatherProvider.currentWeather;
        final forecastDays = weatherProvider.forecastDays;
        final hourlyForecast = weatherProvider.hourlyForecast;
        final isLoading = weatherProvider.isLoading;
        final error = weatherProvider.error;

        return Scaffold(
          body: SafeArea(
            child: isLoading
                ? _buildLoadingView()
                : error.isNotEmpty
                    ? _buildErrorView(error, weatherProvider)
                    : weather == null
                        ? _buildEmptyView(weatherProvider)
                        : _buildWeatherView(
                            context, 
                            weatherProvider, 
                            weather, 
                            forecastDays, 
                            hourlyForecast,
                          ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Custom loading animation with Indian-inspired colors
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
            strokeWidth: 3,
          ),
          const SizedBox(height: 24),
          const Text(
            'Fetching weather data...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String error, WeatherProvider weatherProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppTheme.deepRed,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => weatherProvider.fetchWeatherByLocation(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(WeatherProvider weatherProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_outlined,
            size: 72,
            color: AppTheme.coolBlue,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Weather Data Available',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => weatherProvider.fetchWeatherByLocation(),
            icon: const Icon(Icons.location_on),
            label: const Text('Use My Location'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherView(
    BuildContext context,
    WeatherProvider weatherProvider,
    weather,
    forecastDays,
    hourlyForecast,
  ) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // App Bar with dynamic coloring based on time
        SliverAppBar(
          backgroundColor: WeatherUtils.getWeatherColor(weather.main),
          expandedHeight: 0,
          pinned: true,
          elevation: 0,
          title: Row(
            children: [
              // Logo
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Image.asset(
                  'assets/icons/logo.png',
                  width: 32,
                  height: 32,
                ),
              ),
              // Search bar
              Expanded(
                child: _buildSearchBar(weatherProvider),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                weatherProvider.useCelsius
                    ? Icons.thermostat
                    : Icons.thermostat_outlined,
              ),
              onPressed: () => weatherProvider.toggleTemperatureUnit(),
              tooltip: 'Toggle temperature unit',
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'settings',
                  child: Row(
                    children: [
                      Icon(Icons.settings, size: 20),
                      SizedBox(width: 8),
                      Text('Settings'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'theme',
                  child: Row(
                    children: [
                      Icon(
                        weatherProvider.themeMode == ThemeMode.dark
                            ? Icons.light_mode
                            : Icons.dark_mode,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        weatherProvider.themeMode == ThemeMode.dark
                            ? 'Light Mode'
                            : 'Dark Mode',
                      ),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'animations',
                  child: Row(
                    children: [
                      Icon(Icons.animation, size: 20),
                      SizedBox(width: 8),
                      Text('Animations Info'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'about',
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 20),
                      SizedBox(width: 8),
                      Text('About'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'theme') {
                  final newMode = weatherProvider.themeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
                  weatherProvider.setThemeMode(newMode);
                } else if (value == 'about') {
                  _showAboutDialog(context);
                } else if (value == 'animations') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutAnimationsScreen(),
                    ),
                  );
                }
                // Handle other menu options
              },
            ),
          ],
        ),
        
        // Current Weather Card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: WeatherCard(
              weather: weather,
              onTap: () {
                // Show detailed weather view
              },
            ),
          ).animate().fadeIn(),
        ),
        
        // Hourly Forecast Title
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Text(
              'Hourly Forecast',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ).animate().fadeIn(delay: 200.ms),
        ),
        
        // Hourly Forecast List
        SliverToBoxAdapter(
          child: SizedBox(
            height: 120,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: hourlyForecast.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedHourIndex = index;
                    });
                  },
                  child: HourlyForecastItem(
                    forecast: hourlyForecast[index],
                    isSelected: index == _selectedHourIndex,
                  ),
                );
              },
            ),
          ).animate().fadeIn(delay: 300.ms),
        ),
        
        // 5-Day Forecast Title
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              '5-Day Forecast',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ).animate().fadeIn(delay: 400.ms),
        ),
        
        // 5-Day Forecast List
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ForecastCard(
                  forecast: forecastDays[index],
                ),
              ).animate().fadeIn(delay: Duration(milliseconds: 500 + (index * 100)));
            },
            childCount: forecastDays.length,
          ),
        ),
        
        // Additional Weather Info section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Additional Info',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                _buildAdditionalInfoCard(context, weather),
              ],
            ),
          ).animate().fadeIn(delay: 600.ms),
        ),
        
        // Sun rise/set info
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _buildSunriseSunsetCard(context, weather),
          ).animate().fadeIn(delay: 700.ms),
        ),
        
        // Bottom spacer
        const SliverToBoxAdapter(
          child: SizedBox(height: 40),
        ),
      ],
    );
  }

  Widget _buildSearchBar(WeatherProvider weatherProvider) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isSearchExpanded ? double.infinity : 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Search Icon/Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                setState(() {
                  _isSearchExpanded = !_isSearchExpanded;
                  if (_isSearchExpanded) {
                    _searchFocusNode.requestFocus();
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  _isSearchExpanded ? Icons.arrow_back : Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          // Expandable Search Field
          if (_isSearchExpanded)
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: const InputDecoration(
                  hintText: 'Search city',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    weatherProvider.fetchWeatherByCity(value);
                    _searchController.clear();
                    setState(() {
                      _isSearchExpanded = false;
                    });
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoCard(BuildContext context, weather) {
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoTile(
                  context,
                  Icons.remove_red_eye_outlined,
                  'Visibility',
                  '${(weather.visibility / 1000).toStringAsFixed(1)} km',
                ),
                _buildInfoTile(
                  context,
                  Icons.compress,
                  'Pressure',
                  '${weather.pressure} hPa',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoTile(
                  context,
                  Icons.thermostat_outlined,
                  'Min Temp',
                  '${weatherProvider.getTemperatureWithUnit(weather.tempMin)}',
                ),
                _buildInfoTile(
                  context,
                  Icons.thermostat,
                  'Max Temp',
                  '${weatherProvider.getTemperatureWithUnit(weather.tempMax)}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSunriseSunsetCard(BuildContext context, weather) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _buildSunDetailTile(
                    context,
                    Icons.wb_sunny_outlined,
                    'Sunrise',
                    WeatherUtils.formatTime(weather.sunrise),
                    AppTheme.warmYellow,
                  ),
                ),
                Container(
                  height: 60,
                  width: 1,
                  color: Theme.of(context).dividerColor,
                ),
                Expanded(
                  child: _buildSunDetailTile(
                    context,
                    Icons.nightlight_round,
                    'Sunset',
                    WeatherUtils.formatTime(weather.sunset),
                    AppTheme.coolBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSunDetailTile(
    BuildContext context,
    IconData icon,
    String label,
    String time,
    Color iconColor,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Mausam Weather',
      applicationVersion: '1.0.0',
      applicationIcon: Image.asset(
        'assets/icons/logo.png',
        width: 48,
        height: 48,
      ),
      applicationLegalese: '© 2023 Mausam Weather',
      children: [
        const SizedBox(height: 16),
        const Text(
          'A beautiful, modern weather app with Indian design aesthetics, built with Flutter.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        const Text(
          'Weather data provided by WeatherAPI.com',
          style: TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
} 