import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/theme/theme_bloc.dart';
import 'blocs/todo/todo_bloc.dart';
import 'screens/todo_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = SharedPreferencesAsync();
  final savedTheme = await prefs.getString(ThemeBloc.storageKey);
  final initialTheme = ThemeBloc.themeModeFromString(savedTheme);
  runApp(
    MyApp(
      prefs: prefs,
      initialThemeMode: initialTheme,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.prefs,
    required this.initialThemeMode,
  });

  final SharedPreferencesAsync prefs;
  final ThemeMode initialThemeMode;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TodoBloc()),
        BlocProvider(
          create: (_) => ThemeBloc(
            prefs: prefs,
            initialMode: initialThemeMode,
          ),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'TODO アプリ',
            theme: ThemeBloc.lightTheme,
            darkTheme: ThemeBloc.darkTheme,
            themeMode: themeState.themeMode,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
