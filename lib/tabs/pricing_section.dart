import 'package:flutter/material.dart';

class PricingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Pricing Plans',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 64),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              PlanCard(
                title: 'Starter',
                price: '\$29/mo',
                description: 'Perfect for beginners',
                features: [
                  '1 Social Media Account',
                  '50 Listings/month',
                  'Basic AI Analysis',
                  'Email Support'
                ],
              ),
              PlanCard(
                title: 'Professional',
                price: '\$79/mo',
                description: 'For growing businesses',
                features: [
                  '3 Social Media Accounts',
                  '200 Listings/month',
                  'Advanced AI Analysis',
                  'Priority Support'
                ],
                isPopular: true,
              ),
              PlanCard(
                title: 'Enterprise',
                price: 'Custom',
                description: 'For large organizations',
                features: [
                  'Unlimited Accounts',
                  'Unlimited Listings',
                  'Custom AI Solutions',
                  'Dedicated Support'
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final List<String> features;
  final bool isPopular;

  const PlanCard({
    required this.title,
    required this.price,
    required this.description,
    required this.features,
    this.isPopular = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isPopular ? Border.all(color: Colors.yellow, width: 2) : null,
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
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Most Popular',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
          ),
          const SizedBox(height: 24),
          ...features
              .map((feature) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.yellow.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Choose Plan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
