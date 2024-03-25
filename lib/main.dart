import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_sebep_kurs/firebase_options.dart';
import 'package:whats_app_sebep_kurs/view/home/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const WhatsApp());
}

class WhatsApp extends StatelessWidget {
  const WhatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeView(),
    );
  }
}
