import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final GetStorage _box = GetStorage();
  final _key = 'isdarkmode';
  _saveThemeToBox(bool isdarkmode) {
    _box.write(_key, isdarkmode);
  }

  bool _loadThemeFrombox() {
    return _box.read<bool>(_key) ?? false;
  }

  ThemeMode get Theme {
    if (_loadThemeFrombox()) {
      return ThemeMode.dark;
    }
    return ThemeMode.light;
  }

  void switchTheme() {
    
    Get.changeThemeMode(_loadThemeFrombox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFrombox());
  }
}
