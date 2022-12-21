import 'package:flutter/material.dart';

/// Styles - Contains the design system for the entire app.
/// Includes paddings, text styles, timings etc. Colors (other than gradients)
/// are not included, and are defined in theme.dart instead.

//TODO: It's a little stupid to have med and offset as the same size.
class Insets {
  /// Allows for dynamic insets that can scale with device size
  /// A scale of 1 corresponds to a standard phone size (iPhone 13 Pro).
  static double scale = 1;
  static double offsetScale = 1;

  static double get xs => 5 * scale;
  static double get sm => 10 * scale;
  static double get med => 15 * scale;
  static double get lg => 20 * scale;
  static double get xl => 30 * scale;

  /// The offset of every page from the border of the device.
  static double get offset => 15 * offsetScale;
}

class Corners {
  static const double sm = 5;
  static const Radius smRadius = Radius.circular(sm);
  static const BorderRadius smBorderRadius = BorderRadius.all(smRadius);

  static const double med = 10;
  static const Radius medRadius = Radius.circular(med);
  static const BorderRadius medBorderRadius = BorderRadius.all(medRadius);

  static const double lg = 20;
  static const Radius lgRadius = Radius.circular(lg);
  static const BorderRadius lgBorderRadius = BorderRadius.all(lgRadius);
}

/// The duration used for all animations.
class Durations {
  static const Duration universal = Duration(milliseconds: 400);
}

/// Standardized gradients used to accentuate certain UI elements of the app.
class Gradients {
  static const List<Color> colors = [
    Color(0xFFC93030),
    Color(0xFFF63B3B),
    Color(0xFFF54949),
  ];
}

/// Font Sizes - These are usually not used directly, but are instead referenced
/// to create predefined styles in [TextStyles].
class FontSizes {
  /// Allows for dynamic font sizes that can scale with device size.
  static double scale = 1;

  static double get s12 => 12 * scale;
  static double get s14 => 14 * scale;
  static double get s16 => 16 * scale;
  static double get s18 => 18 * scale;
  static double get s20 => 20 * scale;
  static double get s24 => 24 * scale;
}

/// Fonts - A list of Font Families, used by the TextStyles class to create
/// concrete styles.
class Fonts {}

/// TextStyles - All core text styles for the app are be declared here.
/// Every variant in the app is not declared here; just the high level ones.
/// More specific variants are created on the fly using `style.copyWith()`
/// Ex: newStyle = TextStyles.body1.copyWith(lineHeight: 2, color: Colors.red)
class TextStyles {
  static TextStyle get h1 =>
      TextStyle(fontSize: FontSizes.s24, fontWeight: FontWeight.bold);
  static TextStyle get h2 =>
      h1.copyWith(fontSize: FontSizes.s20, fontWeight: FontWeight.w500);
  static TextStyle get title1 =>
      TextStyle(fontSize: FontSizes.s18, fontWeight: FontWeight.bold);
  static TextStyle get body1 =>
      TextStyle(fontSize: FontSizes.s16, fontWeight: FontWeight.normal);
  static TextStyle get body2 => body1.copyWith(fontSize: FontSizes.s14);
  static TextStyle get caption =>
      TextStyle(fontSize: FontSizes.s12, fontWeight: FontWeight.normal);
}
