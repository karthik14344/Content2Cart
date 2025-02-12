// models/instagram_post.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class InstagramPost {
  final String postUrl;
  final String imageUrl;
  final List<String> carouselImages;
  final bool isConverted;
  final DateTime? created_at;
  final String title;
  final String description;
  final double price;
  final String category;
  final String brand;
  final List<String> features;
  final Map<String, dynamic> specs;

  InstagramPost({
    required this.postUrl,
    required this.imageUrl,
    this.carouselImages = const [],
    this.isConverted = false,
    this.created_at,
    this.title = '',
    this.description = '',
    this.price = 0.0,
    this.category = '',
    this.brand = '',
    this.features = const [],
    this.specs = const {},
  });

  // Add fromJson factory constructor
  factory InstagramPost.fromJson(Map<String, dynamic> json) {
    return InstagramPost(
      postUrl: json['post_url'] ?? '',
      imageUrl: json['image_url'] ?? '',
      carouselImages: List<String>.from(json['carousel_images'] ?? []),
      isConverted: json['is_converted'] ?? false,
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      brand: json['brand'] ?? '',
      features: List<String>.from(json['features'] ?? []),
      specs: Map<String, dynamic>.from(json['specs'] ?? {}),
    );
  }

  // Add fromUrl factory constructor
  factory InstagramPost.fromUrl(String url) {
    return InstagramPost(
      postUrl: url,
      imageUrl: url,
      carouselImages: [],
      isConverted: false,
      created_at: DateTime.now(),
      title: '',
      description: '',
      price: 0.0,
      category: '',
      brand: '',
      features: [],
      specs: {},
    );
  }

  // Add fromFirestore factory constructor
  factory InstagramPost.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return InstagramPost(
      postUrl: data['post_url'] ?? '',
      imageUrl: data['image_url'] ?? '',
      carouselImages: List<String>.from(data['carousel_images'] ?? []),
      isConverted: data['is_converted'] ?? false,
      created_at: data['created_at'] != null
          ? (data['created_at'] as Timestamp).toDate()
          : null,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      category: data['category'] ?? '',
      brand: data['brand'] ?? '',
      features: List<String>.from(data['features'] ?? []),
      specs: Map<String, dynamic>.from(data['specs'] ?? {}),
    );
  }

  // Add toJson method for serialization
  Map<String, dynamic> toJson() {
    return {
      'post_url': postUrl,
      'image_url': imageUrl,
      'carousel_images': carouselImages,
      'is_converted': isConverted,
      'created_at': created_at?.toIso8601String(),
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'brand': brand,
      'features': features,
      'specs': specs,
    };
  }

  // Add toMap method for Firebase
  Map<String, dynamic> toMap() {
    return toJson();
  }

  // Utility methods
  bool get hasCarousel => carouselImages.isNotEmpty;
  int get totalImages => 1 + carouselImages.length;
}
