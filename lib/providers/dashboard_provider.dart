// lib/providers/dashboard_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final dashboardStatsProvider = StreamProvider<DashboardStats>((ref) {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return Stream.value(DashboardStats());

  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('posts')
      .snapshots()
      .map((snapshot) {
    final convertedCount =
        snapshot.docs.where((doc) => doc.data()['is_converted'] == true).length;

    final publishedCount =
        snapshot.docs.where((doc) => doc.data()['is_published'] == true).length;

    return DashboardStats(
      totalListings: convertedCount,
      approvedListings: publishedCount,
      disapprovedListings: convertedCount - publishedCount,
    );
  });
});

class DashboardStats {
  final int totalListings;
  final int approvedListings;
  final int disapprovedListings;

  DashboardStats({
    this.totalListings = 0,
    this.approvedListings = 0,
    this.disapprovedListings = 0,
  });
}
