import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/store_shell.dart';
import 'state/store_controller.dart';

void main() {
  runApp(const StoreApp());
}

class StoreApp extends StatefulWidget {
  const StoreApp({super.key});

  @override
  State<StoreApp> createState() => _StoreAppState();
}

class _StoreAppState extends State<StoreApp> {
  final StoreController _controller = StoreController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = GoogleFonts.interTextTheme();
    final themedText = baseTextTheme.copyWith(
      displayLarge: GoogleFonts.montserrat(
        fontSize: 48,
        height: 1.1,
        letterSpacing: -0.02,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: GoogleFonts.montserrat(
        fontSize: 32,
        height: 1.2,
        letterSpacing: -0.01,
        fontWeight: FontWeight.w500,
      ),
      headlineMedium: GoogleFonts.montserrat(
        fontSize: 24,
        height: 1.3,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: GoogleFonts.montserrat(
        fontSize: 20,
        height: 1.3,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.inter(fontSize: 18, height: 1.6),
      bodyMedium: GoogleFonts.inter(fontSize: 16, height: 1.6),
      bodySmall: GoogleFonts.inter(fontSize: 14, height: 1.5),
      labelSmall: GoogleFonts.montserrat(
        fontSize: 12,
        height: 1,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
    );

    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF000000),
        onPrimary: Color(0xFFFFFFFF),
        secondary: Color(0xFF4E5F7C),
        onSecondary: Color(0xFFFFFFFF),
        surface: Color(0xFFF9F9F9),
        onSurface: Color(0xFF1A1C1C),
        background: Color(0xFFF9F9F9),
        onBackground: Color(0xFF1A1C1C),
        error: Color(0xFFBA1A1A),
        onError: Color(0xFFFFFFFF),
        surfaceVariant: Color(0xFFE2E2E2),
        outline: Color(0xFF7E7576),
      ),
      scaffoldBackgroundColor: const Color(0xFFF9F9F9),
      textTheme: themedText,
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFF9F9F9),
        foregroundColor: const Color(0xFF1A1C1C),
        elevation: 0,
        titleTextStyle: themedText.headlineSmall,
      ),
    );

    return MaterialApp(
      title: 'Toko Baju',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => StoreShell(controller: _controller),
      ),
    );
  }
}
