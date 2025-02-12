import 'package:flutter/material.dart';

class FeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      color: Colors.yellow.shade50,
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 800;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Powerful Features',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  FeatureCard(
                    title: 'AI Content Analysis',
                    description:
                        'Automatically extracts product details, pricing, and specifications from your social media posts',
                    icon: Icons.auto_awesome,
                    width: isWideScreen ? 300 : constraints.maxWidth * 0.9,
                  ),
                  FeatureCard(
                    title: 'Multi-Platform Integration',
                    description:
                        'Seamlessly connects with Instagram and expands to more platforms soon',
                    icon: Icons.share,
                    width: isWideScreen ? 300 : constraints.maxWidth * 0.9,
                  ),
                  FeatureCard(
                    title: 'Image Analysis',
                    description:
                        'Advanced visual recognition for product details and features',
                    icon: Icons.image_search,
                    width: isWideScreen ? 300 : constraints.maxWidth * 0.9,
                  ),
                  FeatureCard(
                    title: 'Real-time Processing',
                    description:
                        'Instant analysis and listing generation for your content',
                    icon: Icons.speed,
                    width: isWideScreen ? 300 : constraints.maxWidth * 0.9,
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

class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final double width;

  const FeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    this.width = 300,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.yellow.shade700),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      ),
    );
  }
}
