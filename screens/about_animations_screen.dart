import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../themes/app_theme.dart';

class AboutAnimationsScreen extends StatelessWidget {
  const AboutAnimationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Animations'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Current Animations',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16),
              _buildAnimationsList(),
              const SizedBox(height: 24),
              const Text(
                'Get More Animations',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'You can download free weather animations from:',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () {
                          _copyToClipboard(context, 'https://lottiefiles.com/');
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.link,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'LottieFiles.com',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.content_copy,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Instructions:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInstructionStep(
                        '1', 
                        'Search for weather animations on LottieFiles.com'
                      ),
                      _buildInstructionStep(
                        '2', 
                        'Download the animation as a JSON file'
                      ),
                      _buildInstructionStep(
                        '3', 
                        'Add the JSON file to your "assets/animations/" directory'
                      ),
                      _buildInstructionStep(
                        '4', 
                        'Update the getWeatherIcon method in weather_utils.dart if needed'
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Missing Animations',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16),
              _buildMissingAnimationsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimationsList() {
    final animations = [
      {'name': 'Clear Day', 'file': 'assets/animations/clear-day.json'},
      {'name': 'Partly Cloudy', 'file': 'assets/animations/partly-cloudy-night.json'},
      {'name': 'Cloudy', 'file': 'assets/animations/cloudy.json'},
      {'name': 'Rain', 'file': 'assets/animations/rain.json'},
      {'name': 'Rain Day', 'file': 'assets/animations/rain-day.json'},
      {'name': 'Thunderstorm', 'file': 'assets/animations/thunderstorm.json'},
      {'name': 'Mist', 'file': 'assets/animations/mist.json'},
    ];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: animations.length,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Lottie.asset(
                    animations[index]['file']!,
                    animate: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  animations[index]['name']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMissingAnimationsList() {
    final missingAnimations = [
      'Clear Night',
      'Partly Cloudy Day',
      'Rain Night',
      'Snow',
    ];
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'You may want to add these animations for a complete experience:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ...missingAnimations.map((name) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(String number, String instruction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              instruction,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
} 