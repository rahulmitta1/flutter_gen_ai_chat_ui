import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'examples/home_screen.dart';
// New streamlined examples
import 'examples/01_basic/basic_chat_screen.dart';
import 'examples/02_intermediate/intermediate_chat_screen.dart';
import 'examples/03_complete/complete_showcase.dart';
import 'examples/04_file_media_chat/file_media_chat.dart';

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
            // Define streamlined routes
            initialRoute: '/',
            routes: {
              '/': (context) => const ExamplesHomeScreen(),
              '/basic': (context) => const BasicChatScreen(),
              '/intermediate': (context) => const IntermediateChatScreen(),
              '/complete-showcase': (context) => const CompleteShowcase(),
              '/file-media-chat': (context) => const FileMediaChat(),
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
