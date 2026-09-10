import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'screens/welcome_screen.dart';
import 'screens/app_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const ZadApp());
  } catch (e) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF9F9FC),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.settings_outlined,
                    size: 56, color: Color(0xFF0D631B)),
                const SizedBox(height: 24),
                const Text(
                  'إعداد Firebase مطلوب',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1C1E)),
                ),
                const SizedBox(height: 12),
                const Text(
                  'لتشغيل التطبيق على المتصفح، يجب إضافة إعدادات Firebase Web.\n\nأضف تطبيق Web في Firebase Console وأضف appId إلى firebase_options.dart',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15, color: Color(0xFF40493D), height: 1.5),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E8EA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    e.toString(),
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF40493D),
                        fontFamily: 'monospace'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class ZadApp extends StatelessWidget {
  const ZadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZAD',
      theme: zadLightTheme().copyWith(
        textTheme: GoogleFonts.interTextTheme(zadLightTheme().textTheme),
      ),
      debugShowCheckedModeBanner: false,
      home: const _AuthGate(),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: ZadColors.background,
            body: Center(
              child: CircularProgressIndicator(color: ZadColors.primary),
            ),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return const AppShell();
        }
        return const WelcomeScreen();
      },
    );
  }
}
