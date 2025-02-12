// api_service.dart
import 'dart:async';
import 'dart:io';

import 'package:content2cart/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // Remove trailing slash from baseUrl
  static const String baseUrl = 'http://192.168.1.9:3000/api'; // change here
  final AuthService _authService = AuthService();

  // Helper method to build URLs correctly
  Uri _buildUrl(String endpoint) {
    final cleanEndpoint =
        endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    return Uri.parse('$baseUrl/$cleanEndpoint');
  }

  // Get authentication token using the new helper method
  Future<String?> _getAuthToken() async {
    try {
      final token = await _authService.getIdToken();
      if (token != null) {
        print(
            'Got auth token: ${token.substring(0, 10)}...'); // Debug log (truncated)
      }
      return token;
    } catch (e) {
      print('Error getting auth token: $e');
      return null;
    }
  }

  // Headers with authentication
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _getAuthToken();
    if (token == null) throw Exception('Not authenticated');

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Accept': '*/*',
      'Access-Control-Allow-Origin': '*',
    };
  }

  // Check authentication before making requests
  void _checkAuthentication() {
    if (!_authService.isSignedIn) {
      throw Exception('User not authenticated');
    }
  }

  Future<List<String>> fetchInstagramPosts(String username) async {
    try {
      _checkAuthentication();
      print('Fetching posts for: $username');

      final headers = await _getAuthHeaders();
      final url = _buildUrl('analyze');

      print('Making request to: ${url.toString()}');
      print('Headers: $headers');
      print('Request body: ${jsonEncode({'username': username})}');

      // Add timeout to help diagnose connection issues
      final response = await http
          .post(
            url,
            headers: headers,
            body: jsonEncode({'username': username}),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () =>
                throw TimeoutException('Request timed out after 30 seconds'),
          );

      print('Response status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => item['post_link'].toString())
            .where((link) => link.startsWith('https://www.instagram.com/p/'))
            .toList();
      } else {
        throw Exception(
            'Server error: ${response.statusCode}\nBody: ${response.body}');
      }
    } catch (e) {
      print('Error in fetchInstagramPosts: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> convertPost(String postUrl) async {
    try {
      _checkAuthentication();
      print('Converting post: $postUrl');

      final headers = await _getAuthHeaders();
      final response = await http.post(
        _buildUrl('analyze/convert'),
        headers: headers,
        body: jsonEncode({'post_url': postUrl}),
      );

      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to convert post: ${response.statusCode}\nBody: ${response.body}');
      }
    } catch (e) {
      print('Error in convertPost: $e');
      throw Exception('Failed to convert post: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUserPosts() async {
    try {
      _checkAuthentication();
      final headers = await _getAuthHeaders();
      final response = await http.get(
        _buildUrl('user/posts'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception(
            'Failed to fetch user posts: ${response.statusCode}\nBody: ${response.body}');
      }
    } catch (e) {
      print('Error fetching user posts: $e');
      throw Exception('Failed to fetch user posts: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUserProducts() async {
    try {
      _checkAuthentication();
      final headers = await _getAuthHeaders();
      final response = await http.get(
        _buildUrl('user/products'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception(
            'Failed to fetch user products: ${response.statusCode}\nBody: ${response.body}');
      }
    } catch (e) {
      print('Error fetching user products: $e');
      throw Exception('Failed to fetch user products: $e');
    }
  }
}
