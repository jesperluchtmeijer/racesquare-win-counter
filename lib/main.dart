import 'package:flutter/material.dart';
import 'package:racesquare_teller/ui/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hoolufixeiscluknevqs.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhvb2x1Zml4ZWlzY2x1a25ldnFzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTcxODQwMDQsImV4cCI6MjAzMjc2MDAwNH0.de7lbVqnCXVScUi5GyctFkBzl471YtdxZ0iAR5aYv-s',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RaceSquare Counter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        backgroundColor: Colors.white,
        body: Home(),
      ),
    );
  }
}
