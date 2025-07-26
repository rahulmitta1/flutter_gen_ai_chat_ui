import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../models/app_state.dart';

/// A real file upload example that demonstrates how to use the Flutter Gen AI Chat UI
/// with actual file picking and image selection functionality.
class RealFileUploadExample extends StatefulWidget {
  const RealFileUploadExample({super.key});

  @override
  State<RealFileUploadExample> createState() => _RealFileUploadExampleState();
}

class _RealFileUploadExampleState extends State<RealFileUploadExample> {
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

  // File pickers
  final ImagePicker _imagePicker = ImagePicker();

  // Temporary files
  final List<File> _temporaryFiles = [];

  @override
  void initState() {
    super.initState();

    // Add welcome message
    _chatController.addMessage(
      ChatMessage(
        text: '# Real File Upload Example 📤\n\n'
            'This example demonstrates real file upload capabilities:\n\n'
            '- **Image uploads** from camera or gallery\n'
            '- **Document uploads** from file system\n'
            '- **Multiple file selection**\n'
            '- **File preview** before sending\n\n'
            'Try uploading files using the attachment button!',
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
      ),
    );
  }

  /// Handle file upload selection
  Future<void> _handleFileUpload(List<Object> files) async {
    // Show a bottom sheet with file upload options
    await showModalBottomSheet(
      context: context,
      builder: (context) => _buildFileUploadOptions(context),
    );
  }

  /// Build the futuristic file upload options bottom sheet
  Widget _buildFileUploadOptions(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [const Color(0xFF0A0A0F), const Color(0xFF1A1B23)]
              : [const Color(0xFFF8F9FF), const Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border.all(
          color: isDarkMode 
              ? const Color(0xFF374151).withOpacity(0.3)
              : const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Upload Options',
              style: TextStyle(
                color: isDarkMode 
                    ? const Color(0xFFF3F4F6)
                    : const Color(0xFF1F2937),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildFuturisticUploadOption(
            context,
            icon: Icons.camera_alt_rounded,
            title: 'Take Photo',
            subtitle: 'Capture using camera',
            gradient: const LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF059669)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          _buildFuturisticUploadOption(
            context,
            icon: Icons.photo_library_rounded,
            title: 'Choose from Gallery',
            subtitle: 'Pick from photo library',
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
          _buildFuturisticUploadOption(
            context,
            icon: Icons.description_rounded,
            title: 'Upload Document',
            subtitle: 'PDF, Word, Excel files',
            gradient: const LinearGradient(
              colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onTap: () {
              Navigator.pop(context);
              _pickFile();
            },
          ),
          _buildFuturisticUploadOption(
            context,
            icon: Icons.folder_copy_rounded,
            title: 'Multiple Files',
            subtitle: 'Select multiple files at once',
            gradient: const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onTap: () {
              Navigator.pop(context);
              _pickMultipleFiles();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Build a futuristic upload option tile
  Widget _buildFuturisticUploadOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode 
            ? const Color(0xFF1A1B23).withOpacity(0.6)
            : const Color(0xFFFFFFFF).withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode 
              ? const Color(0xFF374151).withOpacity(0.3)
              : const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.colors.first.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: isDarkMode 
                              ? const Color(0xFF6B7280)
                              : const Color(0xFF9CA3AF),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDarkMode 
                      ? const Color(0xFF6B7280)
                      : const Color(0xFF9CA3AF),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Pick an image from the camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final File file = File(pickedFile.path);

        // Show caption dialog
        if (!mounted) return;
        final String? caption = await _showCaptionDialog(context);

        // Send file with the caption (empty string if skipped)
        _sendFileMessage([file], caption ?? '');
      }
    } catch (e) {
      _showErrorSnackBar('Error picking image: $e');
    }
  }

  /// Show a dialog to add a caption to an image
  Future<String?> _showCaptionDialog(BuildContext context) {
    final TextEditingController captionController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a caption'),
          content: TextField(
            controller: captionController,
            decoration: const InputDecoration(
              hintText: 'Enter a caption for your image...',
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Skip caption
              child: const Text('Skip'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context)
                  .pop(captionController.text), // Add caption
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  /// Pick a single file
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File file = File(result.files.single.path!);

        // For documents, we could use the same caption feature or a different dialog
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

        // For multiple files, we might want a different caption approach
        if (!mounted) return;
        final String? caption =
            await _showMultipleFilesCaptionDialog(context, files.length);

        _sendFileMessage(files, caption ?? '');
      }
    } catch (e) {
      _showErrorSnackBar('Error picking files: $e');
    }
  }

  /// Show a dialog for multiple files caption
  Future<String?> _showMultipleFilesCaptionDialog(
      BuildContext context, int fileCount) {
    final TextEditingController captionController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a caption for $fileCount files'),
          content: TextField(
            controller: captionController,
            decoration: const InputDecoration(
              hintText: 'Enter a caption for your files...',
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Skip caption
              child: const Text('Skip'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context)
                  .pop(captionController.text), // Add caption
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  /// Send a message with file attachments
  void _sendFileMessage(List<File> files, String caption) async {
    try {
      // Create media attachments from files
      List<ChatMedia> media = [];

      for (File file in files) {
        // Get file information
        String fileName = path.basename(file.path);
        int fileSize = await file.length();
        String fileExtension =
            path.extension(file.path).toLowerCase().replaceAll('.', '');

        // Save the file to app documents directory to make it accessible
        // (this step is necessary especially for temporary camera files)
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String appDocPath = appDocDir.path;
        final String destFilePath =
            '$appDocPath/${DateTime.now().millisecondsSinceEpoch}_$fileName';

        final File destFile = await file.copy(destFilePath);
        _temporaryFiles.add(destFile); // Store for later cleanup

        // Determine file type
        ChatMediaType mediaType;
        if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(fileExtension)) {
          mediaType = ChatMediaType.image;
        } else if (['mp4', 'mov', 'avi', 'webm'].contains(fileExtension)) {
          mediaType = ChatMediaType.video;
        } else if (['mp3', 'wav', 'ogg', 'm4a'].contains(fileExtension)) {
          mediaType = ChatMediaType.audio;
        } else if (['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt']
            .contains(fileExtension)) {
          mediaType = ChatMediaType.document;
        } else {
          mediaType = ChatMediaType.other;
        }

        // Create chat media object
        // Use file:// URI to access the local file
        media.add(ChatMedia(
          url: 'file://${destFile.path}',
          type: mediaType,
          fileName: fileName,
          extension: fileExtension,
          size: fileSize,
        ));
      }

      // Add user message with attachments
      _chatController.addMessage(
        ChatMessage(
          // Use the caption if provided, otherwise use a default message
          text: caption.isNotEmpty
              ? caption
              : (media.length > 1
                  ? 'I\'ve uploaded ${media.length} files.'
                  : 'I\'ve uploaded a file.'),
          user: _currentUser,
          createdAt: DateTime.now(),
          media: media,
        ),
      );

      // Generate AI response
      _generateAIResponse(media, caption);
    } catch (e) {
      _showErrorSnackBar('Error sending file: $e');
    }
  }

  /// Generate an AI response based on the attachments
  void _generateAIResponse(List<ChatMedia> attachments, String caption) {
    setState(() => _isGenerating = true);

    // Simulate AI processing time
    Future.delayed(const Duration(milliseconds: 1500), () {
      String response = '';
      final bool hasCaption = caption.isNotEmpty;

      if (attachments.length == 1) {
        final media = attachments.first;
        final String captionAcknowledgment =
            hasCaption ? ' and your caption: "${caption}"' : '';

        switch (media.type) {
          case ChatMediaType.image:
            response =
                'I\'ve received your image file$captionAcknowledgment (${_formatFileSize(media.size!)}). I can see this is a ${media.extension?.toUpperCase()} image named "${media.fileName}". Would you like me to analyze the content of this image?';
            break;
          case ChatMediaType.document:
            final extension = media.extension?.toUpperCase() ?? 'DOCUMENT';
            response =
                'I\'ve received your $extension file$captionAcknowledgment (${_formatFileSize(media.size!)}). The document is named "${media.fileName}". Would you like me to extract text or analyze the content of this document?';
            break;
          case ChatMediaType.video:
            response =
                'I\'ve received your video file$captionAcknowledgment (${_formatFileSize(media.size!)}). The file is in ${media.extension?.toUpperCase()} format and is named "${media.fileName}". Would you like me to extract audio or analyze frames from this video?';
            break;
          case ChatMediaType.audio:
            response =
                'I\'ve received your audio file$captionAcknowledgment (${_formatFileSize(media.size!)}). The file is in ${media.extension?.toUpperCase()} format and is named "${media.fileName}". Would you like me to transcribe this audio file or analyze its content?';
            break;
          case ChatMediaType.other:
            response =
                'I\'ve received your file$captionAcknowledgment (${_formatFileSize(media.size!)}). The file is named "${media.fileName}". What would you like me to do with this file?';
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
        final fileNames = attachments.map((m) => m.fileName).join(', ');

        final String captionAcknowledgment =
            hasCaption ? ' with caption: "$caption"' : '';

        response =
            'I\'ve received your ${attachments.length} files$captionAcknowledgment (${_formatFileSize(totalSize)}). The files include $types types, and are named: $fileNames. How would you like me to process these files?';
      }

      _chatController.addMessage(
        ChatMessage(
          text: response,
          user: _aiUser,
          createdAt: DateTime.now(),
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

  /// Show an error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Handle sending a text message
  Future<void> _handleSendMessage(ChatMessage message) async {
    setState(() => _isGenerating = true);

    // Simulate AI processing time
    await Future.delayed(const Duration(milliseconds: 800));

    _chatController.addMessage(
      ChatMessage(
        text:
            'Thanks for your message: "${message.text}"\n\nTo try the file upload functionality, click the attachment button in the input bar.',
        user: _aiUser,
        createdAt: DateTime.now(),
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
      backgroundColor: isDarkMode ? const Color(0xFF0A0A0F) : const Color(0xFFF8F9FF),
      appBar: _buildFuturisticAppBar(context, appState, isDarkMode),
      body: AiChatWidget(
        // Required parameters
        currentUser: _currentUser,
        aiUser: _aiUser,
        controller: _chatController,
        onSendMessage: _handleSendMessage,

        // Max width constraint
        maxWidth: appState.chatMaxWidth,

        // Loading configuration with futuristic styling
        loadingConfig: LoadingConfig(
          isLoading: _isGenerating,
          loadingIndicator: _isGenerating ? _buildFuturisticLoadingIndicator() : null,
        ),

        // Message customization with futuristic styling
        messageOptions: MessageOptions(
          showUserName: true,
          showTime: true,
          enableImageTaps: true,
          onMediaTap: (media) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Opened: ${media.fileName ?? 'File'}'),
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
          uploadIcon: Icons.cloud_upload_rounded,
          uploadIconColor: isDarkMode 
              ? const Color(0xFF00D4FF) 
              : const Color(0xFF6366F1),
          uploadTooltip: 'Upload real files',
          onFilesSelected: _handleFileUpload,
          maxFilesPerMessage: 10,
        ),

        // Futuristic input field styling
        inputOptions: InputOptions(
          sendOnEnter: true,
          sendButtonPadding: const EdgeInsets.only(right: 12),
          sendButtonIconSize: 22,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: InputDecoration(
            hintText: 'Message or upload real files...',
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          ),
          textStyle: TextStyle(
            color: isDarkMode 
                ? const Color(0xFFF3F4F6) 
                : const Color(0xFF1F2937),
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
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
            color: isDarkMode 
                ? const Color(0xFF00D4FF)
                : const Color(0xFF6366F1),
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
                      : const Color(0xFF6366F1)).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.cloud_upload_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Real File Upload',
                style: TextStyle(
                  color: isDarkMode 
                      ? const Color(0xFFF3F4F6)
                      : const Color(0xFF1F2937),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Actual device files',
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
          margin: const EdgeInsets.only(right: 8),
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
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: isDarkMode 
                  ? const Color(0xFF00D4FF)
                  : const Color(0xFF6366F1),
              size: 22,
            ),
            onPressed: () {
              _chatController.clearMessages();
              _chatController.addMessage(
                ChatMessage(
                  text: '# Real File Upload Example 📤\n\n'
                      'This example demonstrates real file upload capabilities:\n\n'
                      '- **Image uploads** from camera or gallery\n'
                      '- **Document uploads** from file system\n'
                      '- **Multiple file selection**\n'
                      '- **File preview** before sending\n\n'
                      'Try uploading files using the attachment button!',
                  user: _aiUser,
                  createdAt: DateTime.now(),
                  isMarkdown: true,
                ),
              );
            },
            tooltip: 'Reset conversation',
          ),
        ),
      ],
    );
  }

  /// Build futuristic loading indicator
  Widget _buildFuturisticLoadingIndicator() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return LoadingWidget(
      texts: [
        "Processing upload...",
        "Analyzing file content...",
        "Generating response...",
        "Ready to assist...",
      ],
      shimmerBaseColor: isDarkMode 
          ? const Color(0xFF1F2937)
          : const Color(0xFFE5E7EB),
      shimmerHighlightColor: isDarkMode 
          ? const Color(0xFF00D4FF).withOpacity(0.3)
          : const Color(0xFF6366F1).withOpacity(0.2),
    );
  }

  @override
  void dispose() {
    // Clean up temporary files
    for (File file in _temporaryFiles) {
      try {
        if (file.existsSync()) {
          file.deleteSync();
        }
      } catch (_) {
        // Ignore errors on cleanup
      }
    }

    _chatController.dispose();
    super.dispose();
  }
}
