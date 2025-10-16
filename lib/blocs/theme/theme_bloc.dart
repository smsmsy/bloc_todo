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
    required SharedPreferencesAsync prefs,
    ThemeMode initialMode = ThemeMode.light,
  }) : _prefs = prefs,
       super(ThemeState(themeMode: initialMode)) {
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

  static const Color _seedColor = Colors.blue;

  static final _themeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(centerTitle: true),
  );

  static final ThemeData lightTheme = _themeData.copyWith(
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = _themeData.copyWith(
    brightness: Brightness.dark,
  );
}
