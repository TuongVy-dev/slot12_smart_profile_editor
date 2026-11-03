import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/profile_model.dart';

class ApiService {
  // JSONPlaceholder: giả lập user id=1
  final String baseUrl = "https://jsonplaceholder.typicode.com/users/1";

  Future<Profile> fetchProfile() async {
    final uri = Uri.parse(baseUrl);
    final response = await http.get(uri);

    // Log để SV thấy rõ
    // ignore: avoid_print
    print("GET $uri -> ${response.statusCode}");
    // ignore: avoid_print
    print("Body: ${response.body}");

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      return Profile.fromJson(jsonMap);
    } else {
      throw Exception("Failed to load profile (${response.statusCode})");
    }
  }

  Future<void> updateProfile(Profile profile) async {
    final uri = Uri.parse(baseUrl);

    final response = await http.put(
      uri,
      body: jsonEncode(profile.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    // ignore: avoid_print
    print("PUT $uri -> ${response.statusCode}");
    // ignore: avoid_print
    print("Body: ${response.body}");

    // JSONPlaceholder thường trả 200.
    if (response.statusCode != 200) {
      throw Exception("Failed to update profile (${response.statusCode})");
    }
  }
}
