import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF0F0F12); // Very dark blue/black
  static const Color cardBackground = Color(0xFF1C1C23);
  static const Color surface = Color(0xFF1C1C23); // Same as cardBackground for now
  static const Color primary = Color(0xFFFFD700); // Gold
  static const Color secondary = Color(0xFFFF453A); // Vibrant Red
  static const Color accent = Color(0xFF64D2FF); // Light Blue
  static const Color success = Color(0xFF30D158);
  static const Color textMain = Colors.white;
  static const Color textFaint = Colors.white54;
}

class AppTextStyles {
  static TextStyle get display => GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textMain,
  );
  
  static TextStyle get title => GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textMain,
  );

  static TextStyle get body => GoogleFonts.inter(
    fontSize: 16,
    color: AppColors.textMain,
  );

  static TextStyle get label => GoogleFonts.inter(
    fontSize: 14,
    color: AppColors.textFaint,
  );
}
