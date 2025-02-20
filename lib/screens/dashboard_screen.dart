import 'package:content2cart/providers/dashboard_provider.dart';
import 'package:content2cart/screens/about_us_screen.dart';
import 'package:content2cart/screens/link_social_media_screen.dart';
import 'package:content2cart/screens/posts_listing_screen.dart';
import 'package:content2cart/screens/project_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          'Content2Cart',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: isSmallScreen,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          // Profile section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Text(
                    'K',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Hi, Karthik!',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
      drawer: isSmallScreen
          ? NavigationDrawer(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
                Navigator.pop(context);
              },
            )
          : null,
      body: Row(
        children: [
          if (!isSmallScreen)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              extended: !isSmallScreen,
              minExtendedWidth: 200,
              labelType: NavigationRailLabelType.none,
              backgroundColor: Colors.yellow.shade50,
              selectedIconTheme: IconThemeData(color: Colors.yellow.shade800),
              unselectedIconTheme: IconThemeData(color: Colors.black54),
              selectedLabelTextStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelTextStyle: TextStyle(
                color: Colors.black54,
                fontFamily: 'Poppins',
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.link),
                  label: Text('Link Social'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.list_alt),
                  label: Text('Posts Listings'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.info),
                  label: Text('About Us'),
                ),
                // NavigationRailDestination(
                //   icon: Icon(Icons.article),
                //   label: Text('Project Info'),
                // ),
              ],
            ),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: _buildSelectedView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedView() {
    switch (_selectedIndex) {
      case 0:
        return DashboardView();
      case 1:
        return LinkSocialView();
      case 2:
        return PostsListing();
      case 3:
        return AboutUsView();
      // case 4:
      //   return ProjectInfoView();
      default:
        return DashboardView();
    }
  }
}

class NavigationDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const NavigationDrawer({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            color: Colors.yellow,
            padding: EdgeInsets.all(20),
            alignment: Alignment.bottomLeft,
            child: Text(
              'Content2Cart',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildDrawerItem(Icons.dashboard, 'Dashboard', 0),
          _buildDrawerItem(Icons.link, 'Link Social Media', 1),
          _buildDrawerItem(Icons.link, 'Posts Listings', 2),
          _buildDrawerItem(Icons.info, 'About Us', 3),
          _buildDrawerItem(Icons.article, 'Project Info', 4),
          Divider(),
          Spacer(),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'v1.0.0',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Poppins',
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon,
          size: 28,
          color:
              selectedIndex == index ? Colors.yellow.shade800 : Colors.black54),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          color:
              selectedIndex == index ? Colors.yellow.shade800 : Colors.black54,
        ),
      ),
      selected: selectedIndex == index,
      onTap: () => onDestinationSelected(index),
    );
  }
}

class DashboardView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    final statsAsync = ref.watch(dashboardStatsProvider);
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 32),
                statsAsync.when(
                  data: (stats) => Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      _buildCard(
                        'Total Listings',
                        stats.totalListings.toString(),
                        Icons.list_alt,
                        Colors.green,
                      ),
                      _buildCard(
                        'Approved Listings',
                        stats.approvedListings.toString(),
                        Icons.check_circle,
                        Colors.orange,
                      ),
                      _buildCard(
                        'Disapproved Listings',
                        stats.disapprovedListings.toString(),
                        Icons.cancel,
                        Colors.grey,
                      ),
                      _buildCard(
                        'Connected Social Media',
                        '1',
                        Icons.people,
                        Colors.purple,
                      ),
                      _buildCard(
                        'Instagram Listing',
                        '0',
                        MdiIcons.instagram,
                        Colors.red,
                      ),
                      _buildCard(
                        'Facebook Listing',
                        '0',
                        Icons.facebook,
                        Colors.blue,
                      ),
                      // _buildCard(
                      //   'TikTok Listing',
                      //   '0',
                      //   Icons.tiktok,
                      //   Colors.black,
                      // ),
                    ],
                  ),
                  loading: () => Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                    ),
                  ),
                  error: (error, stack) => Center(
                    child: Text('Error loading dashboard stats: $error'),
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
          // Footer
          Positioned(
            left: 100,
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

  Widget _buildCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 250,
      height: 150,
      padding: EdgeInsets.all(16), // Reduced padding
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(8), // Reduced padding
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20), // Smaller icon
          ),
          SizedBox(height: 12), // Reduced spacing
          Text(
            title,
            style: TextStyle(
              fontSize: 14, // Smaller font
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: Colors.black87,
            ),
          ),
          if (value.isNotEmpty) ...[
            SizedBox(height: 4), // Reduced spacing
            Text(
              value,
              style: TextStyle(
                fontSize: 20, // Smaller font
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
