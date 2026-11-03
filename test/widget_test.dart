import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:slot12_smart_profile_editor/main.dart';
import 'package:slot12_smart_profile_editor/models/profile_model.dart';
import 'package:slot12_smart_profile_editor/services/draft_service.dart';

void main() {
  test('Profile JSON round trip + defensive parsing', () {
    final p = Profile.fromJson({'name': 'A', 'email': 'a@b.com', 'phone': null});
    expect(p.phone, '');
    expect(Profile.fromJson(p.toJson()).email, 'a@b.com');
  });

  test('DraftService save / load / clear', () async {
    SharedPreferences.setMockInitialValues({});
    final service = DraftService();
    await service.saveDraft(const Profile(name: 'A', email: 'a@b.com', phone: '0123456789'));
    expect((await service.loadDraft())?.name, 'A');
    await service.clearDraft();
    expect(await service.loadDraft(), isNull);
  });

  testWidgets('Draft is loaded into the form without calling API', (tester) async {
    SharedPreferences.setMockInitialValues({
      DraftService.draftKey: jsonEncode({
        'name': 'Draft Name',
        'email': 'draft@mail.com',
        // Định dạng SĐT giống JSONPlaceholder
        'phone': '1-770-736-8031 x56442',
      }),
    });
    await tester.pumpWidget(const SmartProfileEditorApp());
    await tester.pumpAndSettle();

    expect(find.text('Draft Name'), findsOneWidget);
    expect(find.text('draft@mail.com'), findsOneWidget);

    // Nhập email sai → validation chặn submit
    await tester.enterText(find.byType(TextFormField).at(1), 'abc');
    await tester.tap(find.text('Lưu cập nhật'));
    await tester.pump();
    expect(find.text('Email không hợp lệ (ví dụ: a@b.com)'), findsOneWidget);
    // SĐT có "x" đuôi số máy lẻ vẫn hợp lệ
    expect(find.text('SĐT không hợp lệ (ít nhất 8 ký tự số)'), findsNothing);

    // Cho debounce lưu draft chạy xong
    await tester.pump(const Duration(milliseconds: 500));
  });
}
