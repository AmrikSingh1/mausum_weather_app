import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class AboutAnimationsScreen extends StatelessWidget {
  const AboutAnimationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Animations'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weather Animations',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'This app uses beautiful Lottie animations to represent different weather conditions.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 24.0),
            _buildAnimationInfo(
              'Sunny',
              'assets/animations/sunny.json',
              'Displays when weather is clear or sunny',
            ),
            _buildAnimationInfo(
              'Rainy',
              'assets/animations/rainy.json',
              'Displays during rainy weather conditions',
            ),
            _buildAnimationInfo(
              'Cloudy',
              'assets/animations/cloudy.json',
              'Displays when sky is cloudy or overcast',
            ),
            _buildAnimationInfo(
              'Thunderstorm',
              'assets/animations/thunderstorm.json',
              'Displays during thunderstorms',
            ),
            _buildAnimationInfo(
              'Snow',
              'assets/animations/snow.json',
              'Displays during snowfall',
            ),
            _buildAnimationInfo(
              'Windy',
              'assets/animations/windy.json',
              'Displays during windy conditions',
            ),
            const SizedBox(height: 32.0),
            const Text(
              'Animation Credits',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'All animations are sourced from LottieFiles and are used under their free license for non-commercial use.',
              style: TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationInfo(String title, String assetPath, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'File: $assetPath',
              style: const TextStyle(
                fontSize: 14.0,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              description,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
} 