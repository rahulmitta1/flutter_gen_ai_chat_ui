# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter package (`flutter_gen_ai_chat_ui`) that provides a high-performance UI kit for AI chat applications. The package includes streaming markdown rendering, code highlighting, theming, and customizable integration hooks for major LLMs like ChatGPT, Claude, and Gemini.

**Key Package Info:**
- Current version: 2.3.6
- Multi-platform support: Android, iOS, Linux, macOS, web, Windows
- Minimum Flutter version: 3.7.0
- Minimum Dart SDK: 2.19.0

## Development Commands

### Package Development
```bash
# Install dependencies
flutter pub get

# Run static analysis
flutter analyze

# Run linter (uses flutter_lints with strict rules)
dart analyze --fatal-infos

# Run all tests
flutter test

# Run integration tests
flutter test integration_test/

# Run a specific test file
flutter test test/controllers/chat_messages_controller_test.dart

# Check pub score and package health
dart pub publish --dry-run
```

### Example App Development
```bash
# Navigate to example directory
cd example/

# Install example dependencies
flutter pub get

# Run example app
flutter run

# Run example on specific device
flutter run -d chrome
flutter run -d android
flutter run -d ios

# Run integration tests for examples
flutter test integration_test/
```

### Code Quality & Formatting
```bash
# Format all Dart files
dart format .

# Format specific file
dart format lib/src/widgets/ai_chat_widget.dart

# Check for unused dependencies
flutter pub deps
```

## Architecture & Code Structure

### Core Architecture
The package follows a layered architecture with clear separation of concerns:

**Widget Layer** (`lib/src/widgets/`):
- `AiChatWidget` - Main entry point widget with comprehensive configuration
- `CustomChatWidget` - Lower-level chat implementation 
- `ChatInput` - Configurable input field with multiple styles (minimal, glassmorphic, custom)
- Specialized widgets for animations, loading states, and message rendering

**Controller Layer** (`lib/src/controllers/`):
- `ChatMessagesController` - Central message state management with streaming support
- Handles message addition, updating, deletion, and scroll behavior
- Supports advanced features like response chaining and auto-scroll configuration

**Model Layer** (`lib/src/models/`):
- Chat models: `ChatMessage`, `ChatUser`, `ChatMedia` for media attachments
- Configuration models: `InputOptions`, `MessageOptions`, `WelcomeMessageConfig`
- Specialized models for streaming, file uploads, and UI customization

**Theme System** (`lib/src/theme/`):
- `CustomThemeExtension` - Package-specific theme extensions
- Supports both light and dark modes with extensive customization options

**Utilities** (`lib/src/utils/`):
- `ColorExtensions` - Color manipulation utilities with opacity compatibility
- `GlassmorphicContainer` - Advanced glassmorphism effects
- Font and locale helpers for internationalization

### Key Features & Implementation

**Streaming Text Support:**
- Word-by-word streaming animation (like ChatGPT)
- Configurable streaming duration via `streamingDuration`
- Markdown streaming with `flutter_streaming_text_markdown` integration

**File Upload System (v2.3.0+):**
- `FileUploadOptions` for comprehensive upload configuration
- `ChatMedia` model supporting images, documents, videos
- Multiple file attachments per message
- Platform-specific permission handling

**Advanced Scroll Behavior:**
- `ScrollBehaviorConfig` with preset animation curves
- `AutoScrollBehavior` enum for different scroll triggers
- `scrollToFirstResponseMessage` for long AI responses
- Response chaining with `responseId` and `isStartOfResponse` flags

**Input Field Variants:**
- Default styled input with full customization
- `InputOptions.minimal()` - Clean, borderless style
- `InputOptions.glassmorphic()` - Frosted glass effect with gradients
- `InputOptions.custom()` - Complete custom styling control

### State Management Patterns

The package uses a controller-based pattern similar to Flutter's `TextEditingController`:

```dart
final controller = ChatMessagesController();

// Add messages
controller.addMessage(message);

// Update existing messages (for streaming)
controller.updateMessage(messageId, newText);

// Clear all messages
controller.clearMessages();

// Handle scroll behavior
controller.scrollToBottom();
```

**Provider Integration** (optional):
- Example app demonstrates Provider pattern for theme management
- `AppState` model for managing dark/light mode preferences

### Testing Strategy

**Unit Tests** (`test/`):
- Controller testing with comprehensive message management scenarios
- Widget testing with golden file comparisons
- Scroll behavior and streaming text validation

**Integration Tests** (`integration_test/`):
- Full widget interaction testing
- Cross-platform compatibility validation
- Performance testing for large message lists
- File upload workflow testing

**Test Utilities** (`integration_test/utils/`):
- Shared test helpers for common scenarios
- Mock data generators for consistent testing

## Package Development Workflow

### Adding New Features
1. Create models in `lib/src/models/` for new data structures
2. Implement core logic in appropriate layer (controller/widget/utility)
3. Add comprehensive unit tests in `test/`
4. Create integration tests in `integration_test/`
5. Update example app to demonstrate new feature
6. Update documentation and CHANGELOG.md

### Breaking Changes Protocol
This package is under active development with potential breaking changes. When making breaking changes:
1. Increment major version
2. Document migration path in `doc/MIGRATION.md`
3. Update examples to use new API
4. Provide deprecation warnings when possible

### Publishing Checklist
1. Run `flutter test` and ensure all tests pass
2. Run `flutter analyze` with no issues
3. Update version in `pubspec.yaml`
4. Update `CHANGELOG.md` with all changes
5. Run `dart pub publish --dry-run` to validate
6. Test package with example app on multiple platforms

## Integration Notes

### LLM Integration Patterns
The package is designed to work with streaming responses from various AI providers:

```dart
// Typical streaming integration pattern
void handleStreamingResponse(Stream<String> responseStream) {
  final messageId = controller.addMessage(initialMessage);
  
  responseStream.listen((chunk) {
    controller.updateMessage(messageId, accumulatedText + chunk);
  });
}
```

### Performance Considerations
- Uses `ListView.builder` for efficient message rendering
- Implements shimmer loading for perceived performance
- Configurable message pagination via `PaginationConfig`
- Optimized scroll behavior prevents unnecessary rebuilds

### Accessibility Support
- Full semantic markup for screen readers
- Keyboard navigation support
- High contrast theme support
- RTL language support via `locale_helper.dart`

The codebase emphasizes production-ready features, comprehensive testing, and developer experience with extensive configuration options for different AI chat use cases.