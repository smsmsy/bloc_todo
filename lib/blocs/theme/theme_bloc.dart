import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
}

class LoadThemeEvent extends ThemeEvent {
  @override
  List<Object?> get props => [];
}

class ToggleThemeEvent extends ThemeEvent {
  @override
  List<Object?> get props => [];
}

// State
class ThemeState extends Equatable {
  const ThemeState({required this.themeMode});

  final ThemeMode themeMode;

  @override
  List<Object?> get props => [themeMode];
}

// Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc({
    SharedPreferencesAsync? prefs,
    ThemeMode? initialMode,
  }) : _prefs = prefs ?? SharedPreferencesAsync(),
       super(ThemeState(themeMode: initialMode ?? ThemeMode.light)) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  static const storageKey = 'theme_mode';
  final SharedPreferencesAsync _prefs;

  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final themeValue = await _prefs.getString(storageKey);
    final themeMode = themeModeFromString(themeValue);
    emit(ThemeState(themeMode: themeMode));
  }

  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    emit(ThemeState(themeMode: newMode));
    await _prefs.setString(storageKey, _themeModeToString(newMode));
  }

  static ThemeMode themeModeFromString(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  static String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  static const _lightPrimary = Color(0xFF4A6CF7);
  static const _lightSecondary = Color(0xFF3ECF8E);
  static const _lightBackground = Color(0xFFF4F6FA);
  static const _lightSurface = Color(0xFFFFFFFF);
  static const _lightOnBackground = Color(0xFF1F2933);

  static const _darkPrimary = Color(0xFF7C9CFF);
  static const _darkSecondary = Color(0xFF4FD1A5);
  static const _darkBackground = Color(0xFF111827);
  static const _darkSurface = Color(0xFF1F2933);
  static const _darkOnBackground = Color(0xFFF9FAFB);

  static final ColorScheme _lightColorScheme =
      ColorScheme.fromSeed(
        seedColor: _lightPrimary,
      ).copyWith(
        primary: _lightPrimary,
        secondary: _lightSecondary,
        surface: _lightSurface,
        onSurface: _lightOnBackground,
        surfaceContainerHighest: const Color(0xFFE6ECFF),
        onSurfaceVariant: const Color(0xFF52606D),
        outline: const Color(0xFFCBD2D9),
        outlineVariant: const Color(0xFFE1E7EF),
      );

  static final ColorScheme _darkColorScheme =
      ColorScheme.fromSeed(
        seedColor: _darkPrimary,
        brightness: Brightness.dark,
      ).copyWith(
        primary: _darkPrimary,
        secondary: _darkSecondary,
        surface: _darkSurface,
        onSurface: _darkOnBackground,
        surfaceContainerHighest: const Color(0xFF252F3F),
        onSurfaceVariant: const Color(0xFFC5D0E6),
        outline: const Color(0xFF394455),
        outlineVariant: const Color(0xFF2F3948),
      );

  static TextTheme _buildTextTheme(Brightness brightness, Color onBackground) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
    ).textTheme;

    return base.copyWith(
      headlineLarge: base.headlineLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: onBackground,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: onBackground,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: onBackground,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: onBackground,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        color: onBackground.withValues(alpha: 0.9),
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        color: onBackground.withValues(alpha: 0.8),
      ),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.error),
      ),
    );
  }

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: _lightColorScheme,
    scaffoldBackgroundColor: _lightBackground,
    textTheme: _buildTextTheme(Brightness.light, _lightOnBackground),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: _lightOnBackground,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: _lightOnBackground,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: _lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 4,
      backgroundColor: _lightPrimary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: _lightPrimary,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: const BorderSide(color: _lightPrimary),
        foregroundColor: _lightPrimary,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: _inputDecorationTheme(_lightColorScheme),
    dividerTheme: const DividerThemeData(space: 0, thickness: 1),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(12),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: _darkColorScheme,
    scaffoldBackgroundColor: _darkBackground,
    textTheme: _buildTextTheme(Brightness.dark, _darkOnBackground),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: _darkOnBackground,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: _darkOnBackground,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: _darkSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 4,
      backgroundColor: _darkPrimary,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: _darkPrimary,
        foregroundColor: Colors.black,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: const BorderSide(color: _darkPrimary),
        foregroundColor: _darkPrimary,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: _inputDecorationTheme(_darkColorScheme),
    dividerTheme: const DividerThemeData(space: 0, thickness: 1),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(12),
      ),
    ),
  );
}
