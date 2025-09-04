import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../../models/app_state.dart';

/// Comprehensive file and media chat example combining mock attachments and real uploads
/// Demonstrates complete file handling capabilities with both demonstration modes
class FileMediaChat extends StatefulWidget {
  const FileMediaChat({super.key});

  @override
  State<FileMediaChat> createState() => _FileMediaChatState();
}

class _FileMediaChatState extends State<FileMediaChat>
    with SingleTickerProviderStateMixin {
  // Chat controller to manage messages
  final _chatController = ChatMessagesController();
  late final TabController _tabController;

  // User definitions
  final _currentUser = const ChatUser(id: 'user123', firstName: 'You');
  final _aiUser = const ChatUser(
    id: 'ai123',
    firstName: 'AI Assistant',
    avatar: 'https://ui-avatars.com/api/?name=AI&background=6366f1&color=fff',
  );

  // Loading state
  bool _isGenerating = false;

  // Mock file counter
  int _mockFileCounter = 0;

  // Real file pickers
  final ImagePicker _imagePicker = ImagePicker();
  final List<File> _temporaryFiles = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _addWelcomeMessage();
    _addSampleMessages();
  }

  /// Add welcome message with comprehensive features overview
  void _addWelcomeMessage() {
    _chatController.addMessage(
      ChatMessage(
        text: '# File & Media Chat Hub 🎯\n\n'
            'Comprehensive file handling demonstration:\n\n'
            '## Mock Mode Features\n'
            '- **Interactive preview attachments** with different types\n'
            '- **Multiple format support**: images, videos, audio, documents\n'
            '- **File metadata display** with size and format info\n'
            '- **Batch upload simulation** (multiple files at once)\n\n'
            '## Real Upload Features\n'
            '- **Camera integration** for photo capture\n'
            '- **Gallery selection** from device photos\n'
            '- **Document picker** for PDF, Office files\n'
            '- **Multiple file selection** from file system\n'
            '- **Caption support** for uploaded files\n'
            '- **File type detection** and proper handling\n\n'
            'Use the tabs above to switch between **Mock** and **Real** upload modes!',
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
      ),
    );
  }

  /// Add sample messages with various attachment types for demo
  void _addSampleMessages() {
    Future.delayed(const Duration(milliseconds: 500), () {
      // Sample image message
      _chatController.addMessage(
        ChatMessage(
          text: 'Here\'s a sample image with metadata display.',
          user: _currentUser,
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
          media: [
            ChatMedia(
              url: 'https://picsum.photos/800/600',
              type: ChatMediaType.image,
              fileName: 'scenic_landscape.jpg',
              size: 1024 * 384, // 384 KB
              metadata: {'width': '800', 'height': '600', 'format': 'JPEG'},
            ),
          ],
        ),
      );

      // Sample multiple files message
      _chatController.addMessage(
        ChatMessage(
          text: 'Multiple file types demonstration:',
          user: _currentUser,
          createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
          media: [
            ChatMedia(
              url:
                  'https://file-examples.com/storage/fe13fb068fd4006a98ec0c5/2017/04/file_example_MP4_480_1_5MG.mp4',
              type: ChatMediaType.video,
              fileName: 'presentation_demo.mp4',
              size: (1024 * 1024 * 2.1).toInt(),
              metadata: {
                'thumbnail': 'https://picsum.photos/400/300',
                'duration': '02:15',
                'resolution': '1080p'
              },
            ),
            ChatMedia(
              url: 'https://example.com/report.pdf',
              type: ChatMediaType.document,
              fileName: 'quarterly_report.pdf',
              extension: 'pdf',
              size: (1024 * 1024 * 3.7).toInt(),
            ),
            ChatMedia(
              url:
                  'https://file-examples.com/storage/fe13fb068fd4006a98ec0c5/2017/11/file_example_MP3_700KB.mp3',
              type: ChatMediaType.audio,
              fileName: 'voice_memo.mp3',
              size: 1024 * 850,
            ),
          ],
        ),
      );

      // AI response
      _chatController.addMessage(
        ChatMessage(
          text: 'Perfect! I can see your files:\n\n'
              '• **Video**: 2.1MB presentation in 1080p (02:15 duration)\n'
              '• **Document**: 3.7MB PDF report\n'
              '• **Audio**: 850KB voice memo\n\n'
              'Switch to **Real** mode to try actual file uploads from your device!',
          user: _aiUser,
          createdAt: DateTime.now().subtract(const Duration(minutes: 7)),
          isMarkdown: true,
        ),
      );
    });
  }

  /// Handle mock file upload with rotating file types
  void _handleMockFileUpload(List<Object> files) {
    _mockFileCounter++;
    List<ChatMedia> mockAttachments = [];

    switch (_mockFileCounter % 5) {
      case 1: // High-res image
        mockAttachments = [
          ChatMedia(
            url: 'https://picsum.photos/1200/800',
            type: ChatMediaType.image,
            fileName:
                'high_res_photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
            size: (1024 * 1024 * 1.8).toInt(),
            metadata: {'width': '1200', 'height': '800', 'format': 'JPEG'},
          ),
        ];
        break;

      case 2: // Document bundle
        mockAttachments = [
          ChatMedia(
            url: 'https://example.com/presentation.pptx',
            type: ChatMediaType.document,
            fileName: 'slides_${DateTime.now().millisecondsSinceEpoch}.pptx',
            extension: 'pptx',
            size: (1024 * 1024 * 4.2).toInt(),
          ),
        ];
        break;

      case 3: // Video with metadata
        mockAttachments = [
          ChatMedia(
            url: 'https://example.com/tutorial.mp4',
            type: ChatMediaType.video,
            fileName: 'tutorial_${DateTime.now().millisecondsSinceEpoch}.mp4',
            size: (1024 * 1024 * 12.5).toInt(),
            metadata: {
              'thumbnail': 'https://picsum.photos/640/360',
              'duration': '05:43',
              'resolution': '720p',
              'fps': '30'
            },
          ),
        ];
        break;

      case 4: // Audio collection
        mockAttachments = [
          ChatMedia(
            url: 'https://example.com/music.wav',
            type: ChatMediaType.audio,
            fileName: 'recording_${DateTime.now().millisecondsSinceEpoch}.wav',
            size: (1024 * 1024 * 8.3).toInt(),
            metadata: {
              'duration': '03:21',
              'quality': 'High',
              'channels': 'Stereo'
            },
          ),
        ];
        break;

      case 0: // Mixed media collection
        mockAttachments = [
          ChatMedia(
            url: 'https://picsum.photos/600/400',
            type: ChatMediaType.image,
            fileName: 'screenshot_${DateTime.now().millisecondsSinceEpoch}.png',
            size: 1024 * 567,
            metadata: {'width': '600', 'height': '400', 'format': 'PNG'},
          ),
          ChatMedia(
            url: 'https://example.com/notes.txt',
            type: ChatMediaType.document,
            fileName: 'meeting_notes.txt',
            extension: 'txt',
            size: 1024 * 12,
          ),
        ];
        _mockFileCounter = 0;
        break;
    }

    // Add user message with mock attachments
    _chatController.addMessage(
      ChatMessage(
        text: mockAttachments.length > 1
            ? 'Uploaded ${mockAttachments.length} files for demo'
            : 'Demonstrating ${mockAttachments.first.type.name} upload',
        user: _currentUser,
        createdAt: DateTime.now(),
        media: mockAttachments,
      ),
    );

    _generateAIResponse(mockAttachments, 'mock');
  }

  /// Handle real file upload selection
  Future<void> _handleRealFileUpload(List<Object> files) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildUploadOptionsBottomSheet(context),
    );
  }

  /// Build upload options bottom sheet
  Widget _buildUploadOptionsBottomSheet(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [const Color(0xFF0A0A0F), const Color(0xFF1A1B23)]
              : [const Color(0xFFF8F9FF), const Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        border: Border.all(
          color: isDarkMode
              ? const Color(0xFF374151).withOpacity(0.3)
              : const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 16),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF374151)
                  : const Color(0xFFD1D5DB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Text(
            'Real Upload Options',
            style: TextStyle(
              color: isDarkMode
                  ? const Color(0xFFF3F4F6)
                  : const Color(0xFF1F2937),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose how you want to upload files',
            style: TextStyle(
              color: isDarkMode
                  ? const Color(0xFF6B7280)
                  : const Color(0xFF9CA3AF),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildUploadOptionCard(
                  context,
                  icon: Icons.camera_alt_rounded,
                  title: 'Camera',
                  subtitle: 'Take photo',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                _buildUploadOptionCard(
                  context,
                  icon: Icons.photo_library_rounded,
                  title: 'Gallery',
                  subtitle: 'Pick photos',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                _buildUploadOptionCard(
                  context,
                  icon: Icons.description_rounded,
                  title: 'Document',
                  subtitle: 'PDF, Office',
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickFile();
                  },
                ),
                _buildUploadOptionCard(
                  context,
                  icon: Icons.folder_copy_rounded,
                  title: 'Multiple',
                  subtitle: 'Batch select',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickMultipleFiles();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build upload option card
  Widget _buildUploadOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1A1B23).withOpacity(0.6)
            : const Color(0xFFFFFFFF).withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode
              ? const Color(0xFF374151).withOpacity(0.3)
              : const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.colors.first.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: isDarkMode
                        ? const Color(0xFFF3F4F6)
                        : const Color(0xFF1F2937),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
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
          ),
        ),
      ),
    );
  }

  /// Pick image from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final File file = File(pickedFile.path);
        if (!mounted) return;
        final String? caption = await _showCaptionDialog(context);
        _sendFileMessage([file], caption ?? '');
      }
    } catch (e) {
      _showErrorSnackBar('Error picking image: $e');
    }
  }

  /// Show caption dialog
  Future<String?> _showCaptionDialog(BuildContext context) {
    final TextEditingController captionController = TextEditingController();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1A1B23) : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Add Caption',
            style: TextStyle(
              color: isDarkMode
                  ? const Color(0xFFF3F4F6)
                  : const Color(0xFF1F2937),
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: captionController,
            style: TextStyle(
              color: isDarkMode
                  ? const Color(0xFFF3F4F6)
                  : const Color(0xFF1F2937),
            ),
            decoration: InputDecoration(
              hintText: 'Enter caption for your file...',
              hintStyle: TextStyle(
                color: isDarkMode
                    ? const Color(0xFF6B7280)
                    : const Color(0xFF9CA3AF),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Skip',
                style: TextStyle(
                  color: isDarkMode
                      ? const Color(0xFF6B7280)
                      : const Color(0xFF9CA3AF),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pop(captionController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  /// Pick single file
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        File file = File(result.files.single.path!);
        if (!mounted) return;
        final String? caption = await _showCaptionDialog(context);
        _sendFileMessage([file], caption ?? '');
      }
    } catch (e) {
      _showErrorSnackBar('Error picking file: $e');
    }
  }

  /// Pick multiple files
  Future<void> _pickMultipleFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );
      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        if (!mounted) return;
        final String? caption = await _showCaptionDialog(context);
        _sendFileMessage(files, caption ?? '');
      }
    } catch (e) {
      _showErrorSnackBar('Error picking files: $e');
    }
  }

  /// Send real file message
  void _sendFileMessage(List<File> files, String caption) async {
    try {
      List<ChatMedia> media = [];

      for (File file in files) {
        String fileName = path.basename(file.path);
        int fileSize = await file.length();
        String fileExtension =
            path.extension(file.path).toLowerCase().replaceAll('.', '');

        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String destFilePath =
            '${appDocDir.path}/${DateTime.now().millisecondsSinceEpoch}_$fileName';
        final File destFile = await file.copy(destFilePath);
        _temporaryFiles.add(destFile);

        ChatMediaType mediaType = _getMediaType(fileExtension);

        media.add(ChatMedia(
          url: 'file://${destFile.path}',
          type: mediaType,
          fileName: fileName,
          extension: fileExtension,
          size: fileSize,
        ));
      }

      _chatController.addMessage(
        ChatMessage(
          text: caption.isNotEmpty
              ? caption
              : (media.length > 1
                  ? 'Uploaded ${media.length} real files from device'
                  : 'Uploaded a file from device'),
          user: _currentUser,
          createdAt: DateTime.now(),
          media: media,
        ),
      );

      _generateAIResponse(media, 'real');
    } catch (e) {
      _showErrorSnackBar('Error sending file: $e');
    }
  }

  /// Get media type from file extension
  ChatMediaType _getMediaType(String extension) {
    if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)) {
      return ChatMediaType.image;
    } else if (['mp4', 'mov', 'avi', 'webm'].contains(extension)) {
      return ChatMediaType.video;
    } else if (['mp3', 'wav', 'ogg', 'm4a'].contains(extension)) {
      return ChatMediaType.audio;
    } else if (['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt']
        .contains(extension)) {
      return ChatMediaType.document;
    }
    return ChatMediaType.other;
  }

  /// Generate AI response based on attachments and mode
  void _generateAIResponse(List<ChatMedia> attachments, String mode) {
    setState(() => _isGenerating = true);

    Future.delayed(const Duration(milliseconds: 1500), () {
      String response = _buildResponseText(attachments, mode);

      _chatController.addMessage(
        ChatMessage(
          text: response,
          user: _aiUser,
          createdAt: DateTime.now(),
          isMarkdown: true,
        ),
      );

      setState(() => _isGenerating = false);
    });
  }

  /// Build AI response text
  String _buildResponseText(List<ChatMedia> attachments, String mode) {
    final isReal = mode == 'real';
    final prefix = isReal ? '**Real Upload**' : '**Mock Demo**';

    if (attachments.length == 1) {
      final media = attachments.first;
      final sizeText = _formatFileSize(media.size!);

      switch (media.type) {
        case ChatMediaType.image:
          return '$prefix: Received ${media.extension?.toUpperCase()} image "${{
            media.fileName
          }}" (${sizeText}). ${isReal ? 'This is an actual file from your device!' : 'This demonstrates image preview capabilities.'}';
        case ChatMediaType.document:
          return '$prefix: Received ${media.extension?.toUpperCase()} document "${{
            media.fileName
          }}" (${sizeText}). ${isReal ? 'Real document analysis available!' : 'Shows document attachment UI.'}';
        case ChatMediaType.video:
          return '$prefix: Received video "${{
            media.fileName
          }}" (${sizeText}). ${isReal ? 'Actual video processing ready!' : 'Video preview demonstration.'}';
        case ChatMediaType.audio:
          return '$prefix: Received audio "${{
            media.fileName
          }}" (${sizeText}). ${isReal ? 'Real audio transcription possible!' : 'Audio file UI demonstration.'}';
        default:
          return '$prefix: Received file "${{
            media.fileName
          }}" (${sizeText}). ${isReal ? 'Ready for processing!' : 'File attachment demo.'}';
      }
    } else {
      final totalSize =
          attachments.fold<int>(0, (sum, media) => sum + (media.size ?? 0));
      final types = attachments.map((m) => m.type.name).toSet().join(', ');
      return '$prefix: Received ${attachments.length} files (${_formatFileSize(totalSize)}) including: $types. ${isReal ? 'All files are real and ready for processing!' : 'Multiple file attachment demonstration complete.'}';
    }
  }

  /// Handle text message sending
  Future<void> _handleSendMessage(ChatMessage message) async {
    setState(() => _isGenerating = true);

    await Future.delayed(const Duration(milliseconds: 800));

    _chatController.addMessage(
      ChatMessage(
        text: 'Message received! Try the attachment features:\n\n'
            '• **Mock Mode**: Demonstrates UI with sample files\n'
            '• **Real Mode**: Upload actual files from your device\n\n'
            'Switch between tabs to explore different upload experiences!',
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
      ),
    );

    setState(() => _isGenerating = false);
  }

  /// Format file size
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Show error snack bar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor:
            isDarkMode ? const Color(0xFF0A0A0F) : const Color(0xFFF8F9FF),
        appBar: _buildAppBar(context, appState, isDarkMode),
        body: Column(
          children: [
            _buildTabBar(isDarkMode),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMockChatTab(appState, isDarkMode),
                  _buildRealChatTab(appState, isDarkMode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar(
      BuildContext context, AppState appState, bool isDarkMode) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [
                    const Color(0xFF0A0A0F),
                    const Color(0xFF1A1B23).withOpacity(0.8)
                  ]
                : [
                    const Color(0xFFF8F9FF),
                    const Color(0xFFFFFFFF).withOpacity(0.9)
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
            child: const Icon(Icons.folder_shared_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'File & Media Chat',
                style: TextStyle(
                  color: isDarkMode
                      ? const Color(0xFFF3F4F6)
                      : const Color(0xFF1F2937),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Mock + Real uploads',
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

  /// Build tab bar
  Widget _buildTabBar(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1F2937).withValues(alpha: 0.8)
            : const Color(0xFFFFFFFF).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? const Color(0xFF374151).withValues(alpha: 0.5)
              : const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: isDarkMode
                ? [const Color(0xFF00D4FF), const Color(0xFF0EA5E9)]
                : [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
          ),
          boxShadow: [
            BoxShadow(
              color: (isDarkMode
                      ? const Color(0xFF00D4FF)
                      : const Color(0xFF6366F1))
                  .withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor:
            isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF6B7280),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF6B7280),
        ),
        tabs: const [
          Tab(
            text: 'Mock Mode',
            height: 44,
          ),
          Tab(
            text: 'Real Mode',
            height: 44,
          ),
        ],
      ),
    );
  }

  /// Build mock chat tab
  Widget _buildMockChatTab(AppState appState, bool isDarkMode) {
    return AiChatWidget(
      currentUser: _currentUser,
      aiUser: _aiUser,
      controller: _chatController,
      onSendMessage: _handleSendMessage,
      maxWidth: appState.chatMaxWidth,
      loadingConfig: LoadingConfig(
        isLoading: _isGenerating,
        loadingIndicator:
            _isGenerating ? _buildLoadingIndicator(isDarkMode) : null,
      ),
      messageOptions: MessageOptions(
        showUserName: true,
        showTime: true,
        enableImageTaps: true,
        onMediaTap: (media) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Preview: ${media.fileName ?? 'File'}'),
              backgroundColor: isDarkMode
                  ? const Color(0xFF1A1B23)
                  : const Color(0xFF6366F1),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
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
      fileUploadOptions: FileUploadOptions(
        enabled: true,
        uploadIcon: Icons.add_circle_outline_rounded,
        uploadIconColor:
            isDarkMode ? const Color(0xFF00D4FF) : const Color(0xFF6366F1),
        uploadTooltip: 'Mock file demo',
        onFilesSelected: _handleMockFileUpload,
        maxFilesPerMessage: 5,
      ),
      inputOptions: _buildInputOptions(isDarkMode, 'Try mock attachments...'),
    );
  }

  /// Build real chat tab
  Widget _buildRealChatTab(AppState appState, bool isDarkMode) {
    return AiChatWidget(
      currentUser: _currentUser,
      aiUser: _aiUser,
      controller: _chatController,
      onSendMessage: _handleSendMessage,
      maxWidth: appState.chatMaxWidth,
      loadingConfig: LoadingConfig(
        isLoading: _isGenerating,
        loadingIndicator:
            _isGenerating ? _buildLoadingIndicator(isDarkMode) : null,
      ),
      messageOptions: MessageOptions(
        showUserName: true,
        showTime: true,
        enableImageTaps: true,
        onMediaTap: (media) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Real file: ${media.fileName ?? 'File'}'),
              backgroundColor: isDarkMode
                  ? const Color(0xFF1A1B23)
                  : const Color(0xFF6366F1),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
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
      fileUploadOptions: FileUploadOptions(
        enabled: true,
        uploadIcon: Icons.cloud_upload_rounded,
        uploadIconColor:
            isDarkMode ? const Color(0xFF00D4FF) : const Color(0xFF6366F1),
        uploadTooltip: 'Upload real files',
        onFilesSelected: _handleRealFileUpload,
        maxFilesPerMessage: 10,
      ),
      inputOptions:
          _buildInputOptions(isDarkMode, 'Upload real files from device...'),
    );
  }

  /// Build input options
  InputOptions _buildInputOptions(bool isDarkMode, String hintText) {
    return InputOptions(
      sendOnEnter: true,
      sendButtonPadding: const EdgeInsets.only(right: 12),
      sendButtonIconSize: 22,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
          fontSize: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDarkMode
                ? const Color(0xFF1F2937).withOpacity(0.6)
                : const Color(0xFFE5E7EB),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDarkMode
                ? const Color(0xFF1F2937).withOpacity(0.6)
                : const Color(0xFFE5E7EB),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color:
                isDarkMode ? const Color(0xFF00D4FF) : const Color(0xFF6366F1),
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
        color: isDarkMode ? const Color(0xFFF3F4F6) : const Color(0xFF1F2937),
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  /// Build loading indicator
  Widget _buildLoadingIndicator(bool isDarkMode) {
    return LoadingWidget(
      texts: [
        "Processing files...",
        "Analyzing content...",
        "Generating response...",
        "Ready to assist...",
      ],
      shimmerBaseColor:
          isDarkMode ? const Color(0xFF1F2937) : const Color(0xFFE5E7EB),
      shimmerHighlightColor: isDarkMode
          ? const Color(0xFF00D4FF).withOpacity(0.3)
          : const Color(0xFF6366F1).withOpacity(0.2),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (File file in _temporaryFiles) {
      try {
        if (file.existsSync()) file.deleteSync();
      } catch (_) {}
    }
    _chatController.dispose();
    super.dispose();
  }
}
