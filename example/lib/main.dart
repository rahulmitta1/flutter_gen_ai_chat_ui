import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'examples/home_screen.dart';
// New streamlined examples with Hero Demo
import 'examples/00_hero_demo/hero_demo_screen.dart';
import 'examples/01_basic/enhanced_basic_chat.dart';
import 'examples/02_intermediate/intermediate_chat_screen.dart';
import 'examples/03_complete/complete_showcase.dart';
import 'examples/04_file_media_chat/file_media_chat.dart';
import 'bug_reproduction/welcome_message_bug_screen.dart';

// For state management
import 'models/app_state.dart';

/// Main entry point for the Flutter Gen AI Chat UI Example App
void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: 'Flutter Gen AI Chat UI Examples',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.indigo,
                brightness: Brightness.light,
              ),
              textTheme: GoogleFonts.interTextTheme(),
              useMaterial3: true,
            ),
            darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.indigo,
                brightness: Brightness.dark,
              ),
              textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
            ),
            themeMode: appState.themeMode,
            // Define streamlined routes with Hero Demo
            initialRoute: '/hero-demo', // Start with Hero Demo for immediate impact
            routes: {
              '/': (context) => const ExamplesHomeScreen(),
              '/hero-demo': (context) => const HeroDemoScreen(),
              '/basic': (context) => const EnhancedBasicChat(),
              '/intermediate': (context) => const IntermediateChatScreen(),
              '/complete-showcase': (context) => const CompleteShowcase(),
              '/file-media-chat': (context) => const FileMediaChat(),
              '/welcome-bug': (context) => const WelcomeMessageBugScreen(),
            },
          );
        },
      ),
    );
  }
}

// For a more comprehensive example with advanced features:
// - See the 'comprehensive' directory which demonstrates:
//   - Streaming text responses
//   - Dark/light theme switching
//   - Custom message styling
//   - Animation control
//   - Markdown rendering with code blocks
