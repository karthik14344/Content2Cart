import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HowItWorksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 800;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'How to Use',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Transform your social media content into e-commerce success in three simple steps',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black54,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: [
                  StepCard(
                    number: '1',
                    title: 'Connect Your Social Media',
                    description:
                        'Simply link your Instagram, TikTok, or Facebook accounts to our platform. Your content remains secure and private, while our system begins analyzing your posts intelligently.',
                    width: isWideScreen ? 300 : constraints.maxWidth * 0.8,
                    ths: const [
                      FaIcon(FontAwesomeIcons.instagram),
                      FaIcon(FontAwesomeIcons.tiktok),
                      FaIcon(FontAwesomeIcons.facebook),
                    ],
                  ),
                  StepCard(
                    number: '2',
                    title: 'AI-Powered Analysis',
                    description:
                        'Our advanced AI automatically identifies products, extracts key features, and generates optimized product descriptions. It even suggests competitive pricing based on market data.',
                    width: isWideScreen ? 300 : constraints.maxWidth * 0.8,
                    ths: const [
                      FaIcon(FontAwesomeIcons.qrcode),
                    ],
                  ),
                  StepCard(
                    number: '3',
                    title: 'Automated E-commerce',
                    description:
                        'Review AI-generated listings and publish them to your e-commerce platforms with one click. Updates to your social media automatically sync with your store.',
                    width: isWideScreen ? 300 : constraints.maxWidth * 0.8,
                    ths: const [
                      FaIcon(FontAwesomeIcons.shoppingCart),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class StepCard extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final double width;
  final List<Widget> ths;

  const StepCard({
    required this.number,
    required this.title,
    required this.description,
    required this.width,
    required this.ths,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.yellow.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  number,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black87,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ths.map((icon) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: IconTheme(
                  data: IconThemeData(
                    size: 24,
                    color: Colors.grey.shade700,
                  ),
                  child: icon,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
