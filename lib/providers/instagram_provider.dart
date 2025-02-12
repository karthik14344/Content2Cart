import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/instagram_post.dart';

final instagramProfileProvider = StateProvider<String?>((ref) => null);

final postsProvider =
    StateNotifierProvider<PostsNotifier, List<InstagramPost>>((ref) {
  return PostsNotifier();
});

class PostsNotifier extends StateNotifier<List<InstagramPost>> {
  PostsNotifier() : super([]);

  void setPosts(List<String> urls) {
    state = urls.map((url) => InstagramPost.fromUrl(url)).toList();
  }

  void markAsConverted(String url) {
    state = [
      for (final post in state)
        if (post.postUrl == url)
          InstagramPost(
              postUrl: post.postUrl, isConverted: true, imageUrl: post.imageUrl)
        else
          post,
    ];
  }
}
