import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
class ThemeServices{
  final _storage = GetStorage();
  final _key = 'isDarkMode';

  _saveThemeToStorage(bool isDarkMode)=>_storage.write(_key, isDarkMode);

  bool _loadThemeFromStorage()=>_storage.read(_key)??false;
  ThemeMode get theme => _loadThemeFromStorage() ? ThemeMode.dark : ThemeMode.light;

  void switchTheme(){
    Get.changeThemeMode(_loadThemeFromStorage()?ThemeMode.light:ThemeMode.dark);
    _saveThemeToStorage(!_loadThemeFromStorage());
  }
}