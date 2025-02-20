import 'package:cloud_firestore/cloud_firestore.dart';

class InstagramPost {
  final String id; // Added id field
  final String postUrl;
  final String imageUrl;
  final List<String> carouselImages;
  final bool isConverted;
  final bool isPublished;
  final DateTime? created_at;
  final String title;
  final String description;
  final double price;
  final String category;
  final String brand;
  final List<String> features;
  final Map<String, dynamic> specs;

  InstagramPost({
    this.id = '', // Added to constructor with default value
    required this.postUrl,
    required this.imageUrl,
    this.carouselImages = const [],
    this.isConverted = false,
    this.isPublished = false,
    this.created_at,
    this.title = '',
    this.description = '',
    this.price = 0.0,
    this.category = '',
    this.brand = '',
    this.features = const [],
    this.specs = const {},
  });

  // Updated fromJson factory constructor
  factory InstagramPost.fromJson(Map<String, dynamic> json) {
    return InstagramPost(
      id: json['id'] ?? '',
      postUrl: json['post_url'] ?? '',
      imageUrl: json['image_url'] ?? '',
      carouselImages: List<String>.from(json['carousel_images'] ?? []),
      isConverted: json['is_converted'] ?? false,
      isPublished: json['isPublished'] ?? false,
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

  // Updated fromUrl factory constructor
  factory InstagramPost.fromUrl(String url) {
    return InstagramPost(
      id: '', // Empty id for new posts
      postUrl: url,
      imageUrl: url,
      carouselImages: [],
      isConverted: false,
      isPublished: false,
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

  // Updated fromFirestore factory constructor
  factory InstagramPost.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return InstagramPost(
      id: doc.id, // Get id from DocumentSnapshot
      postUrl: data['post_url'] ?? '',
      imageUrl: data['image_url'] ?? '',
      carouselImages: List<String>.from(data['carousel_images'] ?? []),
      isConverted: data['is_converted'] ?? false,
      isPublished: data['is_published'] ?? false,
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

  // Updated toJson method for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Include id in JSON
      'post_url': postUrl,
      'image_url': imageUrl,
      'carousel_images': carouselImages,
      'is_converted': isConverted,
      'is_published': isPublished,
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

  // Updated toMap method for Firebase
  Map<String, dynamic> toMap() {
    final map = toJson();
    map.remove(
        'id'); // Remove id when saving to Firestore as it's the document ID
    return map;
  }

  // Utility methods remain the same
  bool get hasCarousel => carouselImages.isNotEmpty;
  int get totalImages => 1 + carouselImages.length;

  // Added copyWith method for easy updates
  InstagramPost copyWith({
    String? id,
    String? postUrl,
    String? imageUrl,
    List<String>? carouselImages,
    bool? isConverted,
    bool? isPublished,
    DateTime? created_at,
    String? title,
    String? description,
    double? price,
    String? category,
    String? brand,
    List<String>? features,
    Map<String, dynamic>? specs,
  }) {
    return InstagramPost(
      id: id ?? this.id,
      postUrl: postUrl ?? this.postUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      carouselImages: carouselImages ?? this.carouselImages,
      isConverted: isConverted ?? this.isConverted,
      isPublished: isPublished ?? this.isPublished,
      created_at: created_at ?? this.created_at,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      features: features ?? this.features,
      specs: specs ?? this.specs,
    );
  }
}
