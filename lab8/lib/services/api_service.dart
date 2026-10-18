import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  // Fetches all posts from the REST API.
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await client.get(
        Uri.parse('$_baseUrl/posts'),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  Future<Post> createPost({
    required String title,
    required String body,
    int userId = 1,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$_baseUrl/posts'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'title': title,
          'body': body,
          'userId': userId,
        }),
      ).timeout(const Duration(seconds: 15));;

      if (response.statusCode == 201) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create post (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }
}
