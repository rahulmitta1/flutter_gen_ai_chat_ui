import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'examples/home_screen.dart';
import 'examples/01_basic/basic_chat_screen.dart';
import 'examples/02_intermediate/intermediate_chat_screen.dart';
import 'examples/03_advanced/advanced_chat_screen.dart';
import 'examples/03_advanced/scroll_behavior_example.dart';
import 'examples/04_file_attachments/file_attachments_example.dart';
import 'examples/05_ai_actions/ai_actions_example.dart';
import 'examples/06_context_aware/context_aware_example.dart';
import 'examples/07_advanced_features/advanced_features_example.dart';
import 'examples/08_essential_copilot/essential_copilot_example.dart';
import 'examples/09_advanced_theme_system/advanced_theme_showcase.dart';
import 'examples/simple_ai_actions_example.dart';
import 'examples/real_file_upload_example.dart';
import 'examples/ui_gallery.dart';

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
            // Define all our routes
            initialRoute: '/',
            routes: {
              '/': (context) => const ExamplesHomeScreen(),
              '/basic': (context) => const BasicChatScreen(),
              '/intermediate': (context) => const IntermediateChatScreen(),
              '/advanced': (context) => const AdvancedChatScreen(),
              '/scroll-behavior': (context) => const ScrollBehaviorExample(),
              '/file-attachments': (context) => const FileAttachmentsExample(),
              '/ai-actions': (context) => const AiActionsExample(),
              '/simple-ai-actions': (context) => const SimpleAiActionsExample(),
              '/context-aware': (context) => const ContextAwareExample(),
              '/advanced-features': (context) => const AdvancedFeaturesExample(),
              '/essential-copilot': (context) => const EssentialCopilotExample(),
              '/advanced-theme-showcase': (context) => const AdvancedThemeShowcase(),
              '/real-file-upload': (context) => const RealFileUploadExample(),
              '/ui-gallery': (context) => const UiGalleryScreen(),
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
