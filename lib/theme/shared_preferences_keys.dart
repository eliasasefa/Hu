import 'package:shared_preferences/shared_preferences.dart';
import 'enum.dart';
import 'themes.dart';

class SharedPreferencesKeys {
  _setStringData({required String key, required String text}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, text);
  }

  _setIntData({required String key, required int id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, id);
  }

  Future<String?> _getStringData({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<int?> _getIntData({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  Future<ThemeModeType> getThemeMode() async {
    int? index = await _getIntData(key: 'ThemeModeType');
    if (index != null) {
      return ThemeModeType.values[index];
    } else {
      return ThemeModeType.system;
    }
  }

  Future setThemeMode(ThemeModeType type) async {
    await _setIntData(key: 'ThemeModeType', id: type.index);
  }

  Future<FontFamilyType> getFontType() async {
    int? index = await _getIntData(key: 'FontType');
    if (index != null) {
      return FontFamilyType.values[index];
    } else {
      return FontFamilyType.workSans;
    }
  }

  Future setFontType(FontFamilyType type) async {
    await _setIntData(key: 'FontType', id: type.index);
  }

  Future<ColorType> getColorType() async {
    int? index = await _getIntData(key: 'ColorType');
    if (index != null) {
      return ColorType.values[index];
    } else {
      return ColorType.verdigris;
    }
  }

  Future setColorType(ColorType type) async {
    await _setIntData(key: 'ColorType', id: type.index);
  }
}
