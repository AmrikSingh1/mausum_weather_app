# Mausam Weather App

A modern weather application built with Flutter that provides accurate weather forecasts with a beautiful UI.

## Features

- **Current Weather:** Get real-time weather information for your current location
- **7-Day Forecast:** View detailed weather forecasts for the upcoming week
- **Hourly Forecast:** Check hour-by-hour weather predictions
- **Location Search:** Search for weather information in any city
- **Temperature Units:** Toggle between Celsius and Fahrenheit
- **Dark Mode:** Switch between light and dark themes

## Screenshots

(Screenshots will be added later)

## Technologies Used

- Flutter/Dart
- Provider for state management
- Weather API (WeatherAPI.com) for weather data
- Lottie for animations
- Geolocator for location services

## Getting Started

### Prerequisites

- Flutter (2.10.0 or higher)
- Dart (2.16.0 or higher)
- WeatherAPI.com API key

### Installation

1. Clone the repository
   ```
   git clone https://github.com/AmrikSingh1/mausam_weather_app.git
   ```

2. Navigate to the project directory
   ```
   cd mausam_weather_app
   ```

3. Install dependencies
   ```
   flutter pub get
   ```

4. Update the API key in `lib/services/weather_service.dart`
   ```dart
   static const String apiKey = 'YOUR_WEATHERAPI_KEY';
   ```

5. Run the app
   ```
   flutter run
   ```

## Contributing

Contributions are welcome! Feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Weather data provided by [WeatherAPI.com](https://www.weatherapi.com/)
- Icons and animations from various sources

