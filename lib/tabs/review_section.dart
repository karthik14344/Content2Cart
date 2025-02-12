import 'package:flutter/material.dart';

class ReviewsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      color: Colors.yellow.shade50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'What Our Users Say',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 64),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: const [
              ReviewCard(
                name: 'Sarah Johnson',
                role: 'E-commerce Entrepreneur',
                review:
                    'This platform has transformed how I manage my online business. The AI-powered listings are incredibly accurate.',
                initials: 'SJ',
              ),
              ReviewCard(
                name: 'Mike Chen',
                role: 'Social Media Influencer',
                review:
                    'The seamless integration between social media and e-commerce is exactly what I needed. Highly recommended!',
                initials: 'MC',
              ),
              ReviewCard(
                name: 'Lisa Williams',
                role: 'Small Business Owner',
                review:
                    'The time-saving features and accuracy of the AI analysis have made this an essential tool for my business.',
                initials: 'LW',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String name;
  final String role;
  final String review;
  final String initials;

  const ReviewCard({
    required this.name,
    required this.role,
    required this.review,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                initials,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            role,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            review,
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
