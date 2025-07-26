import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:provider/provider.dart';

import '../../models/app_state.dart';
// Removed unused import for lint compliance
// import '../../services/ai_service.dart';

/// Demonstrates file attachment capabilities of the Flutter Gen AI Chat UI
/// Shows different file types, custom attachment previews, and handling file uploads
class FileAttachmentsExample extends StatefulWidget {
  const FileAttachmentsExample({super.key});

  @override
  State<FileAttachmentsExample> createState() => _FileAttachmentsExampleState();
}

class _FileAttachmentsExampleState extends State<FileAttachmentsExample> {
  // Chat controller to manage messages
  final _chatController = ChatMessagesController();

  // User definitions
  final _currentUser = const ChatUser(id: 'user123', firstName: 'You');
  final _aiUser = const ChatUser(
    id: 'ai123',
    firstName: 'AI Assistant',
    avatar: 'https://ui-avatars.com/api/?name=AI&background=6366f1&color=fff',
  );

  // Loading state
  bool _isGenerating = false;

  // Counter for demo file uploads
  int _clickCounter = 0;

  @override
  void initState() {
    super.initState();

    // Add welcome message
    _chatController.addMessage(
      ChatMessage(
        text: '# File Attachments Example 📂\n\n'
            'This example demonstrates file attachment capabilities:\n\n'
            '- **Image attachments** with thumbnails\n'
            '- **Document attachments** with type-specific icons\n'
            '- **Video and audio files** with custom display\n'
            '- **Multiple attachments** in a single message\n\n'
            'Try uploading different file types using the attachment button!',
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
      ),
    );

    // Add some sample messages with different attachment types
    _addSampleMessages();
  }

  /// Add sample messages with various attachment types to demonstrate the UI
  void _addSampleMessages() {
    // Add a small delay to simulate loading
    Future.delayed(const Duration(milliseconds: 500), () {
      // User sends a message with an image
      _chatController.addMessage(
        ChatMessage(
          text: 'Here\'s an image I want to share with you.',
          user: _currentUser,
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          media: [
            ChatMedia(
              url: 'https://picsum.photos/600/400',
              type: ChatMediaType.image,
              fileName: 'vacation_photo.jpg',
              size: 1024 * 256, // 256 KB
            ),
          ],
        ),
      );

      // AI response about the image
      _chatController.addMessage(
        ChatMessage(
          text:
              'Thanks for sharing the image! It looks great. Do you have any other files you want to share?',
          user: _aiUser,
          createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
        ),
      );

      // User sends multiple attachments
      _chatController.addMessage(
        ChatMessage(
          text: 'Yes, here are some other file types:',
          user: _currentUser,
          createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
          media: [
            ChatMedia(
              url:
                  'https://file-examples.com/storage/fe13fb068fd4006a98ec0c5/2017/04/file_example_MP4_480_1_5MG.mp4',
              type: ChatMediaType.video,
              fileName: 'sample_video.mp4',
              size: (1024 * 1024 * 1.5).toInt(), // 1.5 MB
              metadata: {
                'thumbnail': 'https://picsum.photos/300/200',
                'duration': '00:15',
              },
            ),
            ChatMedia(
              url:
                  'https://file-examples.com/storage/fe13fb068fd4006a98ec0c5/2017/11/file_example_MP3_700KB.mp3',
              type: ChatMediaType.audio,
              fileName: 'audio_sample.mp3',
              size: 1024 * 700, // 700 KB
            ),
          ],
        ),
      );

      // AI response about the files
      _chatController.addMessage(
        ChatMessage(
          text:
              'I see you\'ve shared a video and an audio file. The video is 1.5MB in size and the audio file is 700KB.',
          user: _aiUser,
          createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
      );

      // User sends a document
      _chatController.addMessage(
        ChatMessage(
          text: 'I also have this PDF document to share:',
          user: _currentUser,
          createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
          media: [
            ChatMedia(
              url: 'https://example.com/document.pdf',
              type: ChatMediaType.document,
              fileName: 'project_document.pdf',
              extension: 'pdf',
              size: (1024 * 1024 * 2.7).toInt(), // 2.7 MB
            ),
          ],
        ),
      );

      // AI response about the document
      _chatController.addMessage(
        ChatMessage(
          text:
              'Thanks for sharing the PDF document. It\'s 2.7MB in size. Is there anything specific you want me to review in these files?',
          user: _aiUser,
          createdAt: DateTime.now(),
        ),
      );
    });
  }

  /// Handle file upload button click
  void _handleFileUpload(List<Object> files) {
    // This is just for demonstration - no actual file upload happens
    // In a real app, you would process and upload the files here

    // Simulate different file types based on number of clicks
    // (Since we can't actually select files in this example)
    _clickCounter++;

    // Create different mock file attachments for demonstration
    List<ChatMedia> mockAttachments = [];

    switch (_clickCounter % 4) {
      case 1: // Image
        mockAttachments = [
          ChatMedia(
            url: 'https://picsum.photos/800/600',
            type: ChatMediaType.image,
            fileName: 'new_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
            size: 1024 * 512, // 512 KB
          ),
        ];
        break;

      case 2: // Document
        mockAttachments = [
          ChatMedia(
            url: 'https://example.com/document.docx',
            type: ChatMediaType.document,
            fileName: 'report_${DateTime.now().millisecondsSinceEpoch}.docx',
            extension: 'docx',
            size: (1024 * 1024 * 1.2).toInt(), // 1.2 MB
          ),
        ];
        break;

      case 3: // Video
        mockAttachments = [
          ChatMedia(
            url: 'https://example.com/video.mp4',
            type: ChatMediaType.video,
            fileName: 'video_${DateTime.now().millisecondsSinceEpoch}.mp4',
            size: (1024 * 1024 * 5.8).toInt(), // 5.8 MB
            metadata: {
              'thumbnail': 'https://picsum.photos/400/300',
              'duration': '01:24',
            },
          ),
        ];
        break;

      case 0: // Multiple files (reset counter)
        mockAttachments = [
          ChatMedia(
            url: 'https://picsum.photos/700/500',
            type: ChatMediaType.image,
            fileName: 'image_${DateTime.now().millisecondsSinceEpoch}.jpg',
            size: 1024 * 358, // 358 KB
          ),
          ChatMedia(
            url: 'https://example.com/audio.mp3',
            type: ChatMediaType.audio,
            fileName: 'voice_${DateTime.now().millisecondsSinceEpoch}.mp3',
            size: 1024 * 850, // 850 KB
          ),
        ];
        _clickCounter = 0; // Reset counter
        break;
    }

    // Add user message with attachments
    _chatController.addMessage(
      ChatMessage(
        text:
            'I\'ve just uploaded ${mockAttachments.length > 1 ? 'some files' : 'a file'} for you.',
        user: _currentUser,
        createdAt: DateTime.now(),
        media: mockAttachments,
      ),
    );

    // Generate AI response
    _generateAIResponse(mockAttachments);
  }

  /// Generate an AI response based on the attachments
  void _generateAIResponse(List<ChatMedia> attachments) {
    setState(() => _isGenerating = true);

    // Simulate AI processing time
    Future.delayed(const Duration(milliseconds: 1500), () {
      String response = '';

      if (attachments.length == 1) {
        final media = attachments.first;

        switch (media.type) {
          case ChatMediaType.image:
            response =
                'I\'ve received your image file (${_formatFileSize(media.size!)}). It appears to be a JPEG file. Would you like me to analyze the content of this image?';
            break;
          case ChatMediaType.document:
            final extension = media.extension?.toUpperCase() ?? 'DOCUMENT';
            response =
                'I\'ve received your $extension file (${_formatFileSize(media.size!)}). Would you like me to extract text or analyze the content of this document?';
            break;
          case ChatMediaType.video:
            response =
                'I\'ve received your video file (${_formatFileSize(media.size!)}). The video appears to be ${media.metadata?['duration'] ?? 'unknown'} in length. Would you like me to extract audio or analyze frames from this video?';
            break;
          case ChatMediaType.audio:
            response =
                'I\'ve received your audio file (${_formatFileSize(media.size!)}). Would you like me to transcribe this audio file or analyze its content?';
            break;
          case ChatMediaType.other:
          default:
            response =
                'I\'ve received your file (${_formatFileSize(media.size!)}). What would you like me to do with this file?';
            break;
        }
      } else {
        // Multiple files
        final types = attachments
            .map((m) => m.type.toString().split('.').last)
            .toSet()
            .join(', ');
        final totalSize =
            attachments.fold<int>(0, (sum, media) => sum + (media.size ?? 0));

        response =
            'I\'ve received your ${attachments.length} files (${_formatFileSize(totalSize)}). The files include $types. How would you like me to process these files?';
      }

      _chatController.addMessage(
        ChatMessage(
          text: response,
          user: _aiUser,
          createdAt: DateTime.now(),
          // Include the same attachments in the AI response for reference
          media: attachments,
        ),
      );

      setState(() => _isGenerating = false);
    });
  }

  /// Format file size in human-readable form
  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Handle sending a message and generating a response
  Future<void> _handleSendMessage(ChatMessage message) async {
    // Reset streaming state
    setState(() => _isGenerating = true);

    // Simulate AI processing time
    await Future.delayed(const Duration(milliseconds: 800));

    // Simple response for text-only messages
    _chatController.addMessage(
      ChatMessage(
        text:
            'Thanks for your message! If you\'d like to demonstrate file attachments, try using the attachment button in the input bar.',
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
      ),
    );

    setState(() => _isGenerating = false);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF0A0A0F) : const Color(0xFFF8F9FF),
      appBar: _buildFuturisticAppBar(context, appState, isDarkMode),
      body: AiChatWidget(
        // Required parameters
        currentUser: _currentUser,
        aiUser: _aiUser,
        controller: _chatController,
        onSendMessage: _handleSendMessage,

        // Max width constraint from app state
        maxWidth: appState.chatMaxWidth,

        // Loading configuration
        loadingConfig: LoadingConfig(
          isLoading: _isGenerating,
          loadingIndicator:
              _isGenerating ? _buildCustomLoadingIndicator(colorScheme) : null,
        ),

        // Message customization with futuristic styling
        messageOptions: MessageOptions(
          showUserName: true,
          showTime: true,
          enableImageTaps: true,
          onMediaTap: (media) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tapped on: ${media.fileName ?? 'File'}'),
                backgroundColor: isDarkMode
                    ? const Color(0xFF1A1B23)
                    : const Color(0xFF6366F1),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
          bubbleStyle: BubbleStyle(
            userBubbleColor: isDarkMode
                ? const Color(0xFF1A1B23).withOpacity(0.6)
                : const Color(0xFF6366F1).withOpacity(0.1),
            aiBubbleColor: isDarkMode
                ? const Color(0xFF0F1419).withOpacity(0.8)
                : const Color(0xFFFFFFFF).withOpacity(0.9),
          ),
        ),

        // File upload configuration with futuristic styling
        fileUploadOptions: FileUploadOptions(
          enabled: true,
          uploadIcon: Icons.add_circle_outline_rounded,
          uploadIconColor:
              isDarkMode ? const Color(0xFF00D4FF) : const Color(0xFF6366F1),
          uploadTooltip: 'Attach files',
          onFilesSelected: _handleFileUpload,
          maxFilesPerMessage: 5,
          uploadButtonText: 'Attach',
        ),

        // Futuristic input field styling
        inputOptions: InputOptions(
          sendOnEnter: true,
          sendButtonPadding: const EdgeInsets.only(right: 12),
          sendButtonIconSize: 22,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: InputDecoration(
            hintText: 'Message or attach files...',
            hintStyle: TextStyle(
              color: isDarkMode
                  ? const Color(0xFF6B7280)
                  : const Color(0xFF9CA3AF),
              fontSize: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDarkMode
                    ? const Color(0xFF1F2937).withOpacity(0.6)
                    : const Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDarkMode
                    ? const Color(0xFF1F2937).withOpacity(0.6)
                    : const Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDarkMode
                    ? const Color(0xFF00D4FF)
                    : const Color(0xFF6366F1),
                width: 2,
              ),
            ),
            filled: true,
            fillColor: isDarkMode
                ? const Color(0xFF0F1419).withOpacity(0.8)
                : const Color(0xFFFFFFFF).withOpacity(0.9),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          ),
          textStyle: TextStyle(
            color:
                isDarkMode ? const Color(0xFFF3F4F6) : const Color(0xFF1F2937),
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  /// Custom futuristic loading indicator
  Widget _buildCustomLoadingIndicator(ColorScheme colorScheme) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return LoadingWidget(
      texts: [
        "Processing files...",
        "Analyzing attachments...",
        "Generating response...",
        "Almost ready...",
      ],
      shimmerBaseColor:
          isDarkMode ? const Color(0xFF1F2937) : const Color(0xFFE5E7EB),
      shimmerHighlightColor: isDarkMode
          ? const Color(0xFF00D4FF).withOpacity(0.3)
          : const Color(0xFF6366F1).withOpacity(0.2),
    );
  }

  /// Build futuristic app bar
  PreferredSizeWidget _buildFuturisticAppBar(
    BuildContext context,
    AppState appState,
    bool isDarkMode,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [
                    const Color(0xFF0A0A0F),
                    const Color(0xFF1A1B23).withOpacity(0.8),
                  ]
                : [
                    const Color(0xFFF8F9FF),
                    const Color(0xFFFFFFFF).withOpacity(0.9),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border(
            bottom: BorderSide(
              color: isDarkMode
                  ? const Color(0xFF1F2937).withOpacity(0.3)
                  : const Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color(0xFF1A1B23).withOpacity(0.6)
              : const Color(0xFFFFFFFF).withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode
                ? const Color(0xFF374151).withOpacity(0.3)
                : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color:
                isDarkMode ? const Color(0xFF00D4FF) : const Color(0xFF6366F1),
            size: 18,
          ),
          onPressed: () => Navigator.of(context).pop(),
          padding: EdgeInsets.zero,
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [const Color(0xFF00D4FF), const Color(0xFF0EA5E9)]
                    : [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: (isDarkMode
                          ? const Color(0xFF00D4FF)
                          : const Color(0xFF6366F1))
                      .withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.attach_file_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'File Attachments',
                style: TextStyle(
                  color: isDarkMode
                      ? const Color(0xFFF3F4F6)
                      : const Color(0xFF1F2937),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Minimal & Futuristic',
                style: TextStyle(
                  color: isDarkMode
                      ? const Color(0xFF6B7280)
                      : const Color(0xFF9CA3AF),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey(isDarkMode),
                color: isDarkMode
                    ? const Color(0xFF00D4FF)
                    : const Color(0xFF6366F1),
                size: 22,
              ),
            ),
            onPressed: () => appState.toggleTheme(),
            tooltip: isDarkMode ? 'Light Mode' : 'Dark Mode',
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }
}
