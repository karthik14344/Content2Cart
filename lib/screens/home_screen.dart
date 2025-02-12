import 'package:content2cart/tabs/contact_section.dart';
import 'package:content2cart/tabs/feature_section.dart';
import 'package:content2cart/tabs/hero_section.dart';
import 'package:content2cart/tabs/how_it_works_section.dart';
import 'package:content2cart/tabs/pricing_section.dart';
import 'package:content2cart/tabs/review_section.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  void scrollToIndex(int index) {
    itemScrollController.scrollTo(
      index: index,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text(
          'Content2Cart',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => scrollToIndex(1),
            child: const Text(
              'Features',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TextButton(
            onPressed: () => scrollToIndex(2),
            child: const Text(
              'How It Works',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TextButton(
            onPressed: () => scrollToIndex(3),
            child: const Text(
              'Reviews',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TextButton(
            onPressed: () => scrollToIndex(4),
            child: const Text(
              'Pricing',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TextButton(
            onPressed: () => scrollToIndex(5),
            child: const Text(
              'Contact',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
      body: ScrollablePositionedList.builder(
        itemCount: 6,
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return HeroSection();
            case 1:
              return FeaturesSection();
            case 2:
              return HowItWorksSection();
            case 3:
              return ReviewsSection();
            case 4:
              return PricingSection();
            case 5:
              return ContactSection();
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
