import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  bool _isDarkMode = true;
  double _brightness = 1.0;
  bool _soundEnabled = true;
  String _profileName = 'User';
  String _profilePicturePath = '';
  
  bool get isDarkMode => _isDarkMode;
  double get brightness => _brightness;
  bool get soundEnabled => _soundEnabled;
  String get profileName => _profileName;
  String get profilePicturePath => _profilePicturePath;

  AppProvider() {
    _loadPrefs();
  }

  void _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    _brightness = prefs.getDouble('brightness') ?? 1.0;
    _soundEnabled = prefs.getBool('soundEnabled') ?? true;
    _profileName = prefs.getString('profileName') ?? 'User';
    _profilePicturePath = prefs.getString('profilePicturePath') ?? '';
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  void setBrightness(double value) async {
    _brightness = value;
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('brightness', _brightness);
    notifyListeners();
  }

  void toggleSound() async {
    _soundEnabled = !_soundEnabled;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('soundEnabled', _soundEnabled);
    notifyListeners();
  }

  void updateProfileName(String name) async {
    _profileName = name;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profileName', _profileName);
    notifyListeners();
  }

  void updateProfilePicture(String path) async {
    _profilePicturePath = path;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profilePicturePath', _profilePicturePath);
    notifyListeners();
  }
}
