import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'enum.dart';
import 'shared_preferences_keys.dart';
import 'themes.dart';

class ThemeController extends GetxController {
  bool isLightMode = true;
  ThemeModeType themeModeType = ThemeModeType.system;
  FontFamilyType fontType = FontFamilyType.workSans;
  ColorType colorType = ColorType.verdigris;

  ThemeController({
    required this.themeModeType,
    required this.fontType,
    required this.colorType,
  });

  static Future<ThemeController> init() async {
    ThemeController themeProvider = ThemeController(
      colorType: await SharedPreferencesKeys().getColorType(),
      fontType: await SharedPreferencesKeys().getFontType(),
      themeModeType: await SharedPreferencesKeys().getThemeMode(),
    );
    themeProvider._applyThemeMode(themeProvider.themeModeType);
    return themeProvider;
  }

  Future<void> updateThemeMode(ThemeModeType themeModeTypeData) async {
    await SharedPreferencesKeys().setThemeMode(themeModeTypeData);
    _applyThemeMode(themeModeTypeData);
  }

  void _applyThemeMode(ThemeModeType mode) {
    themeModeType = mode;
    final systemBrightness = Get.context == null
        ? Brightness.light
        : MediaQuery.of(Get.context!).platformBrightness;

    if (mode == ThemeModeType.system) {
      isLightMode = systemBrightness == Brightness.light;
    } else {
      isLightMode = mode == ThemeModeType.light;
    }
    update(); // Notify GetX listeners
  }

  // Additional functions (checkAndSetFonType, updateFontType, etc.) remain unchanged.

// this func is auto check theme and update them
  void checkAndSetThemeMode(Brightness systemBrightness) async {
    bool theLightTheme = isLightMode;

    // mode is selected by user
    themeModeType = await SharedPreferencesKeys().getThemeMode();
    if (themeModeType == ThemeModeType.system) {
      // if mode is system then we add as system birtness
      theLightTheme = systemBrightness == Brightness.light;
    } else if (themeModeType == ThemeModeType.dark) {
      theLightTheme = false;
    } else {
      //light theme selected by user
      theLightTheme = true;
    }

    if (isLightMode != theLightTheme) {
      isLightMode = theLightTheme;
      update();
    }
  }

  void checkAndSetFonType() async {
    final FontFamilyType fontTypeData =
        await SharedPreferencesKeys().getFontType();
    if (fontTypeData != fontType) {
      fontType = fontTypeData;
      update();
    }
  }

  Future updateFontType(FontFamilyType fontTypeData) async {
    await SharedPreferencesKeys().setFontType(fontTypeData);
    fontType = fontTypeData;
    update();
  }

  Future updateColorType(ColorType colorData) async {
    await SharedPreferencesKeys().setColorType(colorData);
    colorType = colorData;
    update();
  }

  void checkAndSetColorType() async {
    final ColorType colorTypeData =
        await SharedPreferencesKeys().getColorType();
    if (colorTypeData != colorType) {
      colorType = colorTypeData;
      update();
    }
  }
}
