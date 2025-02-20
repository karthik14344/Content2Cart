import 'package:content2cart/providers/instagram_provider.dart';
import 'package:content2cart/screens/posts_listing_screen.dart';
import 'package:content2cart/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LinkSocialView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connect Your Social Media Accounts',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Link your accounts to start generating Amazon listings from your content.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 32),
                // Social Media Cards
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _buildSocialCard(
                      context,
                      'assets/images/instagram_logo.png',
                      'Instagram',
                      'Connect your Instagram account',
                    ),
                    _buildSocialCard(
                      context,
                      'assets/images/facebook_logo.png',
                      'Facebook',
                      'Connect your Facebook account',
                    ),
                    // _buildSocialCard(
                    //   context,
                    //   'assets/images/tiktok_logo.png',
                    //   'TikTok',
                    //   'Connect your TikTok account',
                    // ),
                  ],
                ),
                // Activity Section
                SizedBox(height: 48),
                // Text(
                //   'Previously Added Products',
                //   style: TextStyle(
                //     fontSize: 24,
                //     fontWeight: FontWeight.bold,
                //     fontFamily: 'Poppins',
                //   ),
                // ),
                // SizedBox(height: 16),
                // Center(
                //   child: Text(
                //     'No products added yet',
                //     style: TextStyle(
                //       color: Colors.grey[600],
                //       fontFamily: 'Poppins',
                //     ),
                //   ),
                // ),
                SizedBox(height: 100), // Space for footer
              ],
            ),
          ),
          // Footer
          Positioned(
            left: 200,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Made with ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Icon(Icons.favorite, color: Colors.red, size: 20),
                      Text(
                        ' on GenAI',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Team Kanya Rasi',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialCard(
    BuildContext context,
    String logoPath,
    String platform,
    String description,
  ) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo image
          Image.asset(
            logoPath,
            height: 100,
            width: 100,
          ),
          SizedBox(height: 12),
          // Name image
          Image.asset(
            'assets/images/${platform.toLowerCase()}_name.png',
            height: 60,
          ),
          SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showConnectDialog(context, platform),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Connect',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConnectDialog(BuildContext context, String platform) {
    final TextEditingController _usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, _) => AlertDialog(
          title: Text(
            'Connect $platform Account',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Enter your $platform username or profile URL',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_usernameController.text.isNotEmpty) {
                  // Store username in provider
                  ref.read(instagramProfileProvider.notifier).state =
                      _usernameController.text;

                  // Close dialog and show success message
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Instagram account connected successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              child: Text(
                'Connect',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
