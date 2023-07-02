import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_groceries_app/screens/grocery_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 147, 229, 250),
      brightness: Brightness.dark,
      surface: const Color.fromARGB(255, 42, 51, 59),
    );

    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: colorScheme,
          useMaterial3: true,
          // textTheme: GoogleFonts.timmanaTextTheme()
          scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
        ),
        debugShowCheckedModeBanner: false,
        home: const GroceryListScreen(),
      ),
    );
  }
}
