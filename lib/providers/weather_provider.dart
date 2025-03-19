import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  
  Weather? _currentWeather;
  List<ForecastDay> _forecastDays = [];
  List<HourlyForecast> _hourlyForecast = [];
  String _selectedCity = '';
  bool _isLoading = false;
  String _error = '';
  bool _useCelsius = true;
  ThemeMode _themeMode = ThemeMode.system;

  Weather? get currentWeather => _currentWeather;
  List<ForecastDay> get forecastDays => _forecastDays;
  List<HourlyForecast> get hourlyForecast => _hourlyForecast;
  String get selectedCity => _selectedCity;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get useCelsius => _useCelsius;
  ThemeMode get themeMode => _themeMode;

  WeatherProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _useCelsius = prefs.getBool('useCelsius') ?? true;
    _selectedCity = prefs.getString('selectedCity') ?? '';
    final themeModeString = prefs.getString('themeMode') ?? 'system';
    
    switch (themeModeString) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }
    
    notifyListeners();
    
    if (_selectedCity.isNotEmpty) {
      fetchWeatherByCity(_selectedCity);
    } else {
      fetchWeatherByLocation();
    }
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('useCelsius', _useCelsius);
    prefs.setString('selectedCity', _selectedCity);
    
    String themeModeString;
    switch (_themeMode) {
      case ThemeMode.light:
        themeModeString = 'light';
        break;
      case ThemeMode.dark:
        themeModeString = 'dark';
        break;
      default:
        themeModeString = 'system';
    }
    
    prefs.setString('themeMode', themeModeString);
  }

  void toggleTemperatureUnit() {
    _useCelsius = !_useCelsius;
    _savePreferences();
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _savePreferences();
    notifyListeners();
  }

  Future<void> fetchWeatherByCity(String city) async {
    _setLoading(true);
    _error = '';
    
    try {
      _currentWeather = await _weatherService.getWeatherByCity(city);
      _forecastDays = await _weatherService.getForecastByCity(city);
      _hourlyForecast = await _weatherService.getHourlyForecastByCity(city);
      _selectedCity = city;
      _savePreferences();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchWeatherByLocation() async {
    _setLoading(true);
    _error = '';
    
    try {
      final position = await _weatherService.getCurrentLocation();
      await _updateWeatherByPosition(position);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _updateWeatherByPosition(Position position) async {
    try {
      _currentWeather = await _weatherService.getWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      
      _forecastDays = await _weatherService.getForecastByLocation(
        position.latitude,
        position.longitude,
      );
      
      _hourlyForecast = await _weatherService.getHourlyForecastByLocation(
        position.latitude,
        position.longitude,
      );
      
      _selectedCity = _currentWeather?.cityName ?? '';
      _savePreferences();
    } catch (e) {
      _error = e.toString();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Convert temperature from Celsius to Fahrenheit if needed
  double convertTemperature(double tempCelsius) {
    return _useCelsius ? tempCelsius : (tempCelsius * 9 / 5) + 32;
  }

  // Get temperature with unit
  String getTemperatureWithUnit(double tempCelsius) {
    final temp = convertTemperature(tempCelsius).round();
    return '$temp°${_useCelsius ? 'C' : 'F'}';
  }
} 