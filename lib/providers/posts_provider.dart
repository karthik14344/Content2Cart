import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/instagram_post.dart';
import '../services/firebase_service.dart';

// Instagram profile provider
final instagramProfileProvider = StateProvider<String?>((ref) => null);

// Posts provider with Firebase integration
final postsProvider =
    StateNotifierProvider<PostsNotifier, List<InstagramPost>>((ref) {
  return PostsNotifier();
});

class PostsNotifier extends StateNotifier<List<InstagramPost>> {
  PostsNotifier() : super([]);
  final FirebaseService _firebaseService = FirebaseService();

  void setPosts(List<String> urls) {
    // First update local state
    state = urls.map((url) => InstagramPost.fromUrl(url)).toList();

    // Then save to Firebase
    for (var post in state) {
      _firebaseService.addPost(
        postLink: post.postUrl,
        imageUrl: post.imageUrl,
        caption: '', // Add caption if available
      );
    }
  }

  Future<void> markAsConverted(String url) async {
    // Update local state
    state = [
      for (final post in state)
        if (post.postUrl == url)
          InstagramPost(
            postUrl: post.postUrl,
            imageUrl: post.imageUrl,
            isConverted: true,
          )
        else
          post,
    ];

    // Update in Firebase
    try {
      // Find the document ID for this post
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        var snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('posts')
            .where('post_link', isEqualTo: url)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          await _firebaseService.updatePostStatus(
            snapshot.docs.first.id,
            true,
          );
        }
      }
    } catch (e) {
      print('Error updating post status in Firebase: $e');
    }
  }
}
