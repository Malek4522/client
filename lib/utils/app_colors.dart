import 'package:flutter/material.dart';

enum DeliveryType {
  COLD,         // Cold
  COVERED,      // Covered Goods
  FRAGILE,      // Fragile Items
  LIQUID,       // Liquid
  FLAMBLE       // Flamble
}

class AppColors {
  // Primary Colors
  static const Color primaryGreen = Color(0xFF1E6B5C);
  
  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightCard = Colors.white;
  static const Color lightText = Colors.black;
  static const Color lightTextSecondary = Color(0xFF666666);
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkText = Colors.white;
  static const Color darkTextSecondary = Color(0xFFAAAAAA);

  static Color getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkCard : lightCard;
  }

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkText : lightText;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkTextSecondary : lightTextSecondary;
  }
} 