import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:content2cart/screens/product_dialog.dart';
import 'package:content2cart/services/api_services.dart';
import 'package:content2cart/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/instagram_provider.dart';
import '../models/instagram_post.dart';
import 'dart:html' as html;

class PostsListing extends ConsumerStatefulWidget {
  @override
  _PostsListingState createState() => _PostsListingState();
}

class _PostsListingState extends ConsumerState<PostsListing> {
  bool isLoading = false;
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    final instagramProfile = ref.watch(instagramProfileProvider);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Convert Instagram Posts to Product Listings',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: isLoading ? null : _fetchPosts,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Fetch Latest Instagram Posts',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 32),
            StreamBuilder<QuerySnapshot>(
              stream: _firebaseService.getUserPosts(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Error loading posts: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting &&
                    !isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                final posts = snapshot.data?.docs
                        .map((doc) => InstagramPost.fromFirestore(doc))
                        .toList() ??
                    [];

                if (posts.isEmpty && !isLoading) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'No posts found. Click "Fetch Latest Instagram Posts" to load your posts.',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Posts table
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Instagram Post Link',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Action',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 1),
                          ...posts.map((post) => _buildPostRow(post)),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    // Product Cards Grid
                    Text(
                      'Converted Products',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.68,
                        ),
                        itemCount:
                            posts.where((post) => post.isConverted).length,
                        itemBuilder: (context, index) {
                          final convertedPosts =
                              posts.where((post) => post.isConverted).toList();
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: _buildProductCard(convertedPosts[index]),
                          );
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostRow(InstagramPost post) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => _launchURL(post.postUrl),
                  child: Text(
                    _truncateUrl(post.postUrl),
                    style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'Poppins',
                      decoration: TextDecoration.underline,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (post.title.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      post.title,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
              child: // In your widget where the convert button is located
                  ElevatedButton(
            onPressed: () async {
              try {
                final success =
                    await FirebaseService().convertAndStoreImage(post.postUrl);
                if (success) {
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Image converted and stored successfully!')),
                  );
                } else {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to convert image')),
                  );
                }
              } catch (e) {
                // Handle any errors
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
            child: const Text('Convert'),
          )),
        ],
      ),
    );
  }

  Widget _buildProductCard(InstagramPost post) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                post.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[100],
                  child:
                      Icon(Icons.image_not_supported, color: Colors.grey[400]),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  post.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '₹${post.price ?? "N/A"}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[900],
                      ),
                    ),
                    Spacer(),
                    Text(
                      post.brand ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          padding: EdgeInsets.symmetric(vertical: 4),
                          minimumSize: Size(0, 24),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          'Publish',
                          style: TextStyle(fontSize: 11, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          padding: EdgeInsets.symmetric(vertical: 4),
                          minimumSize: Size(0, 24),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          'Edit',
                          style: TextStyle(fontSize: 11, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => ProductDialog(post: post),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          padding: EdgeInsets.symmetric(vertical: 4),
                          minimumSize: Size(0, 24),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          'View',
                          style: TextStyle(fontSize: 11, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _truncateUrl(String url) {
    const int maxLength = 60;
    if (url.length <= maxLength) return url;
    return '${url.substring(0, maxLength)}...';
  }

  void _launchURL(String url) {
    try {
      html.window.open(url, '_blank');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening link: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _convertPost(InstagramPost post) async {
    try {
      final apiService = ApiService();
      await apiService.convertPost(post.postUrl);
      // Firebase will automatically update through the stream
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post converted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error converting post: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchPosts() async {
    final profile = ref.read(instagramProfileProvider);
    if (profile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please connect Instagram account first')),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      final apiService = ApiService();
      await apiService.fetchInstagramPosts(profile);
      // No need to update state manually as Firebase stream will handle it
    } catch (e) {
      print('Error fetching posts: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching posts: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}
