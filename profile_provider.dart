// made by Hamza Mahdi

// my_expense_tracker/lib/logic/providers/profile_provider.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  static const _imageKey = 'profile_image_path';

  bool _isVisible = true;

bool get isVisible => _isVisible;


  File? _profileImage;

  File? get profileImage => _profileImage;

  ProfileProvider() {
    _loadImage();
  }

//  ================= Load Image =================
  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_imageKey);
    if (path != null && File(path).existsSync()) {
      _profileImage = File(path);
      notifyListeners();
    }
  }

//  ================= Pick Image =================
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedFile == null) return;

    final imageFile = File(pickedFile.path);
    _profileImage = imageFile;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imageKey, imageFile.path);

    notifyListeners();
  }

//  ================= Clear Image =================
Future<void> clearProfileImage() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_imageKey);

  _profileImage = null;
  _isVisible = true;
  notifyListeners();
}
// made by Hamza Mahdi

// إخفاء الصورة مؤقتًا (Logout)
void hideProfileImage() {
  _isVisible = false;
  notifyListeners();
}

// إظهار الصورة مجددًا (Login بنفس الحساب)
void showProfileImage() {
  _isVisible = true;
  notifyListeners();
  }
}
