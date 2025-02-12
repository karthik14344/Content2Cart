// services/firebase_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:content2cart/models/instagram_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:convert/convert.dart' as hex;

class FirebaseService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Update this with your API URL
  static const String apiBaseUrl = 'http://192.168.1.9:3000'; // change here

  // Storage path helpers
  String _getMainImagePath(String userId, String productId) {
    return 'users/$userId/products/$productId/main.jpg';
  }

  String _getCarouselImagePath(String userId, String productId, int index) {
    return 'users/$userId/products/$productId/carousel/image_$index.jpg';
  }

  Future<List<InstagramPost>> fetchInstagramPosts(String username) async {
    try {
      // Get the current user's ID token
      final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (idToken == null) throw Exception('Not authenticated');

      print('Got auth token: ${idToken.substring(0, 10)}...');

      final response = await http.post(
        Uri.parse('$apiBaseUrl/api/analyze'), // Note the /api prefix
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({'username': username}),
      );

      print('Making request to: $apiBaseUrl/api/analyze');
      print('Headers: ${response.headers}');
      print('Request body: ${jsonEncode({'username': username})}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => InstagramPost.fromJson(json)).toList();
      } else {
        print('Response status code: ${response.statusCode}');
        print('Response headers: ${response.headers}');
        print('Response body: ${response.body}');
        throw Exception(
            'Server error: ${response.statusCode}\nBody: ${response.body}');
      }
    } catch (e) {
      print('Error in fetchInstagramPosts: $e');
      rethrow;
    }
  }

  // Add a new post
  Future<void> addPost({
    required String postLink,
    required String imageUrl,
    List<String> carouselImages = const [],
    String? caption,
  }) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await _firestore.collection('users').doc(userId).collection('posts').add({
      'post_url': postLink,
      'image_url': imageUrl,
      'carousel_images': carouselImages,
      'is_converted': false,
      'created_at': FieldValue.serverTimestamp(),
      'title': '',
      'description': '',
      'price': 0.0,
      'category': '',
      'brand': '',
      'features': [],
      'specs': {},
    });
  }

  // Update post conversion status
  Future<void> updatePostStatus(String docId, bool isConverted) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('posts')
        .doc(docId)
        .update({'is_converted': isConverted});
  }

  // Get user posts stream
  Stream<QuerySnapshot> getUserPosts() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return Stream.empty();
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('posts')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  // Main method to convert and store images
  Future<bool> convertAndStoreImage(String postUrl) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('No user logged in');

      final idToken = await _auth.currentUser?.getIdToken();
      if (idToken == null) throw Exception('No auth token available');

      final postsRef =
          _firestore.collection('users').doc(userId).collection('posts');
      final querySnapshot =
          await postsRef.where('post_url', isEqualTo: postUrl).limit(1).get();

      if (querySnapshot.docs.isEmpty) throw Exception('Post not found');

      final postDoc = querySnapshot.docs.first;
      final postData = postDoc.data();
      final mainImageUrl = postData['image_url'] as String?;
      final carouselImages =
          List<String>.from(postData['carousel_images'] ?? []);

      if (mainImageUrl == null || mainImageUrl.isEmpty) {
        await postDoc.reference.update({'is_converted': true});
        return true;
      }

      // Fetch main image
      final mainResponse = await http.post(
        Uri.parse('$apiBaseUrl/api/proxy-image'),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'main_url': mainImageUrl,
          'carousel_urls': carouselImages,
        }),
      );

      if (mainResponse.statusCode != 200) {
        throw Exception('Failed to fetch images: ${mainResponse.statusCode}');
      }

      // Upload main image
      final mainBlob = html.Blob([mainResponse.bodyBytes], 'image/jpeg');
      final mainRef =
          _storage.ref().child(_getMainImagePath(userId, postDoc.id));
      await mainRef.putBlob(mainBlob);
      final mainImageDownloadUrl = await mainRef.getDownloadURL();

      // Upload carousel images if present
      List<String> carouselUrls = [];
      for (var i = 0; i < carouselImages.length; i++) {
        try {
          final carouselResponse = await http.post(
            Uri.parse('$apiBaseUrl/api/proxy-image'),
            headers: {
              'Authorization': 'Bearer $idToken',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'main_url': carouselImages[i],
              'carousel_urls': [],
            }),
          );

          if (carouselResponse.statusCode == 200) {
            final carouselBlob =
                html.Blob([carouselResponse.bodyBytes], 'image/jpeg');
            final carouselRef = _storage
                .ref()
                .child(_getCarouselImagePath(userId, postDoc.id, i));
            await carouselRef.putBlob(carouselBlob);
            final carouselUrl = await carouselRef.getDownloadURL();
            carouselUrls.add(carouselUrl);
          }
        } catch (e) {
          print('Error uploading carousel image $i: $e');
        }
      }

      // Update Firestore
      await postDoc.reference.update({
        'is_converted': true,
        'image_url': mainImageDownloadUrl,
        'carousel_images': carouselUrls,
        'storage_path': 'users/$userId/products/${postDoc.id}',
        'converted_at': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error in convertAndStoreImage: $e');
      return false;
    }
  }

// Helper method for image upload
  Future<String?> _uploadImage(
    String userId,
    String postId,
    dynamic imageData,
    String originalUrl,
    bool isMain, {
    int? index,
  }) async {
    try {
      final blob = html.Blob([imageData], 'image/jpeg');
      final String path;

      if (isMain) {
        path = _getMainImagePath(userId, postId);
      } else {
        path = _getCarouselImagePath(userId, postId, index!);
      }

      final ref = _storage.ref().child(path);

      final metadata =
          SettableMetadata(contentType: 'image/jpeg', customMetadata: {
        'userId': userId,
        'postId': postId,
        'originalUrl': originalUrl,
        'imageType': isMain ? 'main' : 'carousel',
        if (!isMain) 'carouselIndex': index.toString(),
        'convertedAt': DateTime.now().toIso8601String(),
      });

      await ref.putBlob(blob, metadata);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading ${isMain ? "main" : "carousel"} image: $e');
      return null;
    }
  }

  // Delete post and its images
  Future<void> deletePost(String postId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('No user logged in');

      // Delete post document
      final postRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('posts')
          .doc(postId);

      final postData = (await postRef.get()).data();
      if (postData == null) return;

      // Delete main image if it exists
      if (postData['image_url'] != null) {
        final mainImageRef =
            _storage.ref().child(_getMainImagePath(userId, postId));
        try {
          await mainImageRef.delete();
        } catch (e) {
          print('Error deleting main image: $e');
        }
      }

      // Delete carousel images if they exist
      final carouselImages =
          List<String>.from(postData['carousel_images'] ?? []);
      for (var i = 0; i < carouselImages.length; i++) {
        try {
          final carouselRef =
              _storage.ref().child(_getCarouselImagePath(userId, postId, i));
          await carouselRef.delete();
        } catch (e) {
          print('Error deleting carousel image $i: $e');
        }
      }

      // Finally delete the post document
      await postRef.delete();
    } catch (e) {
      print('Error in deletePost: $e');
      throw e;
    }
  }
}
