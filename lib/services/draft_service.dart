import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/profile_model.dart';

class DraftService {
  static const String draftKey = "profile_draft";

  Future<void> saveDraft(Profile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(profile.toJson());
    await prefs.setString(draftKey, raw);

    // ignore: avoid_print
    print("Draft saved: $raw");
  }

  Future<Profile?> loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(draftKey);

    // ignore: avoid_print
    print("Draft loaded raw: $raw");

    if (raw == null) return null;

    final jsonMap = jsonDecode(raw) as Map<String, dynamic>;
    return Profile.fromJson(jsonMap);
  }

  Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(draftKey);

    // ignore: avoid_print
    print("Draft cleared");
  }
}
