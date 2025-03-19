import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../themes/app_theme.dart';
import 'weather_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the weather screen after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WeatherScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primary,
              AppTheme.primary.withOpacity(0.7),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo image with animation
              Image.asset(
                'assets/icons/logo.png',
                width: 150,
                height: 150,
              )
              .animate()
              .fadeIn(duration: 500.ms)
              .scale(delay: 200.ms, duration: 500.ms),
              
              const SizedBox(height: 24),
              
              // App name text with animation
              const Text(
                'Mausam',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  letterSpacing: 1.5,
                ),
              )
              .animate()
              .fadeIn(delay: 400.ms)
              .moveY(begin: 20, end: 0, delay: 400.ms, duration: 500.ms),
              
              // Tagline with animation
              const Text(
                'Weather at your fingertips',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              )
              .animate()
              .fadeIn(delay: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
} 