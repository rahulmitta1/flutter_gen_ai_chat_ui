import 'package:flutter/material.dart';

import '../models/ai_chat_config.dart';
import '../models/chat/models.dart';

/// Controller for managing chat messages and their states.
///
/// This controller handles message operations such as adding, updating,
/// and loading more messages. It also manages the welcome message state
/// and loading states for pagination.
class ChatMessagesController extends ChangeNotifier {
  /// Creates a new chat messages controller.
  ///
  /// [initialMessages] - Optional list of messages to initialize the chat with.
  /// [paginationConfig] - Configuration for pagination behavior.
  /// [onLoadMoreMessages] - Callback for loading more messages (for backward compatibility).
  /// [showWelcomeMessage] - Whether to show the welcome message.
  ChatMessagesController({
    final List<ChatMessage>? initialMessages,
    this.paginationConfig = const PaginationConfig(),
    final Future<List<ChatMessage>> Function(ChatMessage? lastMessage)?
        onLoadMoreMessages,
    bool showWelcomeMessage = false,
    ScrollBehaviorConfig? scrollBehaviorConfig,
  }) {
    _scrollBehaviorConfig = scrollBehaviorConfig;

    if (initialMessages != null && initialMessages.isNotEmpty) {
      _messages = List.from(initialMessages);
      _messageCache = {for (var m in _messages) _getMessageId(m): m};
      _showWelcomeMessage = false;
    } else {
      _showWelcomeMessage = showWelcomeMessage;
    }

    // Store the callback for backward compatibility
    _onLoadMoreMessagesCallback = onLoadMoreMessages;
  }

  /// Configuration for pagination behavior
  final PaginationConfig paginationConfig;

  /// Configuration for scroll behavior
  ScrollBehaviorConfig? _scrollBehaviorConfig;

  /// Get the current scroll behavior configuration
  ScrollBehaviorConfig get scrollBehaviorConfig =>
      _scrollBehaviorConfig ?? const ScrollBehaviorConfig();

  /// Set the scroll behavior configuration
  set scrollBehaviorConfig(ScrollBehaviorConfig? config) {
    _scrollBehaviorConfig = config;
    debugPrint('ChatMessagesController: Scroll behavior updated to: '
        '${config?.autoScrollBehavior.toString() ?? "null"}, '
        'scrollToFirstResponseMessage: ${config?.scrollToFirstResponseMessage ?? false}');
  }

  /// Callback for loading more messages (backward compatibility)
  Future<List<ChatMessage>> Function(ChatMessage? lastMessage)?
      _onLoadMoreMessagesCallback;

  List<ChatMessage> _messages = [];
  Map<String, ChatMessage> _messageCache = {};
  bool _showWelcomeMessage = false;
  bool _isLoadingMore = false;
  bool _hasMoreMessages = true;
  int _currentPage = 1;
  ScrollController? _scrollController;

  /// The ID of the first message in the current AI response
  String? _currentResponseFirstMessageId;

  /// The user of the last message added (to track response chains)
  String? _lastMessageUserId;

  /// Is the user manually scrolling
  bool _isManuallyScrolling = false;
  DateTime _lastManualScrollTime = DateTime.now();

  /// Sets the scroll controller for auto-scrolling
  void setScrollController(ScrollController controller) {
    _scrollController = controller;

    // Add listener to detect manual scrolling
    _scrollController?.addListener(() {
      if (_scrollController?.hasClients == true) {
        // If user is dragging or a manual scroll action is happening
        if (_scrollController!.position.isScrollingNotifier.value) {
          _isManuallyScrolling = true;
          _lastManualScrollTime = DateTime.now();
          debugPrint('USER SCROLL: Manual scrolling detected');
        } else if (_isManuallyScrolling) {
          // Reset after a short delay to allow animations to complete
          Future.delayed(const Duration(milliseconds: 300), () {
            if (DateTime.now()
                    .difference(_lastManualScrollTime)
                    .inMilliseconds >=
                300) {
              _isManuallyScrolling = false;
              debugPrint('USER SCROLL: Manual scrolling ended');
            }
          });
        }
      }
    });
  }

  /// Whether more messages are currently being loaded.
  bool get isLoadingMore => _isLoadingMore;

  /// Whether there are more messages to load.
  bool get hasMoreMessages => _hasMoreMessages;

  /// List of all chat messages.
  /// If paginationConfig.reverseOrder is true, newest messages are first (index 0).
  /// If paginationConfig.reverseOrder is false, oldest messages are first (index 0).
  List<ChatMessage> get messages => _messages;

  /// Whether to show the welcome message.
  bool get showWelcomeMessage => _showWelcomeMessage;

  /// Sets whether to show the welcome message
  set showWelcomeMessage(bool value) {
    if (_showWelcomeMessage != value) {
      _showWelcomeMessage = value;
      notifyListeners();
    }
  }

  /// Current page of pagination
  int get currentPage => _currentPage;

  /// Generates a unique ID for a message
  String _getMessageId(ChatMessage message) {
    final customId = message.customProperties?['id'] as String?;
    return customId ??
        '${message.user.id}_${message.createdAt.millisecondsSinceEpoch}_${message.text.hashCode}';
  }

  /// Adds a new message to the chat.
  void addMessage(ChatMessage message) {
    final messageId = _getMessageId(message);
    if (!_messageCache.containsKey(messageId)) {
      // Determine if this is a user message using the ID and properties
      final isFromUser = message.customProperties?['isUserMessage'] as bool? ??
          message.customProperties?['source'] == 'user' ??
          (message.user.id != 'ai' &&
              message.user.id != 'bot' &&
              message.user.id != 'assistant');

      // Get the user ID for response tracking
      final userId = message.user.id;

      // Track if this is the start of a response (user changed and it's not a user message)
      final isStartOfResponse = _lastMessageUserId != userId && !isFromUser;
      _lastMessageUserId = userId;

      // Create a property map to track messaging state
      Map<String, dynamic> updatedProperties = {...?message.customProperties};

      // Track the first message of an AI response
      if (isStartOfResponse) {
        _currentResponseFirstMessageId = messageId;
        // Use a property to mark this as the first message of a response
        updatedProperties['isFirstResponseMessage'] = true;
        debugPrint(
            'NEW RESPONSE: First message ID: $messageId from user: $userId');
      }

      // When a user message appears, we need to reset the first response tracking
      if (isFromUser) {
        // Clear the first response message ID whenever a user sends a message
        // This way, the next AI message will become the first of a new response
        _currentResponseFirstMessageId = null;
        debugPrint('USER MESSAGE: Reset response tracking for user: $userId');
      }

      // Mark user messages for identification
      if (!updatedProperties.containsKey('isUserMessage') &&
          !updatedProperties.containsKey('source')) {
        updatedProperties['isUserMessage'] = isFromUser;
        debugPrint(
            'MESSAGE TYPE: userId=${message.user.id}, isUserMessage=$isFromUser');
      }

      // Create a copy of the message with updated properties
      final updatedMessage =
          message.copyWith(customProperties: updatedProperties);

      if (paginationConfig.reverseOrder) {
        // In reverse order (newest first), new messages go at the beginning (index 0)
        // With ListView.builder(reverse: true), this puts newest messages at the bottom
        _messages.insert(0, updatedMessage);
      } else {
        // In chronological order (oldest first), new messages go at the end
        // With ListView.builder(reverse: false), this puts newest messages at the bottom
        _messages.add(updatedMessage);
      }
      _messageCache[messageId] = updatedMessage;
      notifyListeners();

      // Determine if we should scroll based on the configuration
      final config = scrollBehaviorConfig;

      // Check if this is a user message using our enhanced detection
      final isUserMessage = updatedProperties['isUserMessage'] as bool? ??
          updatedProperties['source'] == 'user';

      bool shouldScroll = false;

      switch (config.autoScrollBehavior) {
        case AutoScrollBehavior.always:
          shouldScroll = true;
          debugPrint('SCROLL DECISION: Always scroll mode - will scroll');
          break;
        case AutoScrollBehavior.onNewMessage:
          shouldScroll = true; // Always scroll for new messages
          debugPrint('SCROLL DECISION: onNewMessage mode - will scroll');
          break;
        case AutoScrollBehavior.onUserMessageOnly:
          shouldScroll = isUserMessage;
          debugPrint(
              'SCROLL DECISION: onUserMessageOnly mode - ${shouldScroll ? "will scroll" : "will NOT scroll"}');
          break;
        case AutoScrollBehavior.never:
          shouldScroll = false;
          debugPrint('SCROLL DECISION: Never scroll mode - will NOT scroll');
          break;
      }

      if (shouldScroll) {
        debugPrint('SCROLLING: After render for isUserMessage=$isUserMessage');
        _scrollAfterRender(isUserMessage, isStartOfResponse, config);
      } else {
        debugPrint('NOT SCROLLING: Message doesn\'t meet scroll criteria');
      }
    }
  }

  /// Scroll after the message is rendered
  void _scrollAfterRender(
      bool isUserMessage, bool isStartOfResponse, ScrollBehaviorConfig config) {
    // Store the current response ID to prevent re-scrolling if it changes during the delay
    final currentResponseId = _currentResponseFirstMessageId;

    // Add a tracking variable to prevent multiple scroll actions
    bool hasScrolled = false;

    // Use a microtask to ensure the message is rendered first
    // Then add a short delay to ensure layout is complete
    Future.microtask(() {
      // Increased delay to ensure rendering is complete
      Future.delayed(const Duration(milliseconds: 200), () {
        // Make sure the widget is still mounted and the response ID hasn't changed
        if (_scrollController?.hasClients != true) {
          debugPrint('SCROLL ABORTED: Scroll controller no longer has clients');
          return;
        }

        debugPrint('SCROLL EXECUTION: isUserMessage=$isUserMessage, '
            'scrollToFirstResponseMessage=${config.scrollToFirstResponseMessage}, '
            'isStartOfResponse=$isStartOfResponse, '
            'currentResponseFirstMessageId=$currentResponseId');

        // If scrollToFirstResponseMessage is true AND this is not a user message AND
        // either this is the start of a response OR we're in always mode
        if (!isUserMessage &&
            config.scrollToFirstResponseMessage &&
            currentResponseId != null &&
            (isStartOfResponse ||
                config.autoScrollBehavior == AutoScrollBehavior.always)) {
          // Double-check that this message ID is still valid before scrolling
          if (_messageCache.containsKey(currentResponseId)) {
            debugPrint('SCROLLING TO FIRST RESPONSE: $currentResponseId');
            scrollToMessage(currentResponseId);
            hasScrolled = true;
          } else {
            debugPrint(
                'INVALID FIRST RESPONSE ID: $currentResponseId - scrolling to bottom instead');
            scrollToBottom(
                config.scrollAnimationDuration, config.scrollAnimationCurve);
            hasScrolled = true;
          }
        }
        // Only scroll to bottom if we haven't already performed a scroll action
        else if (!hasScrolled) {
          // Standard behavior - scroll to bottom
          if (isUserMessage) {
            debugPrint('SCROLLING TO BOTTOM: User message');
          } else if (config.autoScrollBehavior == AutoScrollBehavior.always) {
            debugPrint('SCROLLING TO BOTTOM: Always mode');
          } else {
            debugPrint('SCROLLING TO BOTTOM: Default behavior');
          }

          scrollToBottom(
              config.scrollAnimationDuration, config.scrollAnimationCurve);
        }
      });
    });
  }

  /// Scrolls to a specific message by ID with improved position calculation
  void scrollToMessage(String messageId) {
    if (_scrollController?.hasClients != true) return;

    // Don't interrupt user's manual scrolling
    if (_isManuallyScrolling) {
      debugPrint('SCROLL CANCELED: User is manually scrolling');
      return;
    }

    try {
      // Find the message index
      final index =
          _messages.indexWhere((msg) => _getMessageId(msg) == messageId);
      if (index == -1) {
        debugPrint('MESSAGE NOT FOUND: Cannot scroll to message $messageId');
        return;
      }

      debugPrint('SCROLLING: To message at index $index with ID $messageId');

      // Get configuration for animation timing
      final config = scrollBehaviorConfig;

      // Calculate position based on item index
      if (paginationConfig.reverseOrder) {
        // In reverse mode (newest at bottom)
        if (index == 0) {
          // If it's the newest message, scroll to the start (which is "bottom" in reverse mode)
          debugPrint('REVERSE MODE: Scrolling to newest message (0.0)');
          _scrollController!.animateTo(
            0.0,
            duration: config.scrollAnimationDuration,
            curve: config.scrollAnimationCurve,
          );
        } else {
          // Find 1/3 of the way through the list for a good position to show the message
          final maxExtent = _scrollController!.position.maxScrollExtent;
          final visibleHeight = _scrollController!.position.viewportDimension;
          final itemCount = _messages.length;

          // Get approximate position (1/3 of the way through)
          // For index closer to 0, we'll be closer to the top
          final position =
              maxExtent * (index / itemCount) + (visibleHeight * 0.3);

          debugPrint(
              'REVERSE MODE: Scrolling to position ${position.clamp(0.0, maxExtent)}');

          _scrollController!.animateTo(
            position.clamp(0.0, maxExtent),
            duration: config.scrollAnimationDuration,
            curve: config.scrollAnimationCurve,
          );
        }
      } else {
        // In chronological mode (oldest at top)
        final maxExtent = _scrollController!.position.maxScrollExtent;
        final visibleHeight = _scrollController!.position.viewportDimension;
        final itemCount = _messages.length;

        // Get approximate position (2/3 of the way through)
        // For index closer to itemCount, we'll be closer to the bottom
        final position =
            maxExtent * (index / itemCount) - (visibleHeight * 0.3);

        debugPrint(
            'CHRONOLOGICAL MODE: Scrolling to position ${position.clamp(0.0, maxExtent)}');

        _scrollController!.animateTo(
          position.clamp(0.0, maxExtent),
          duration: config.scrollAnimationDuration,
          curve: config.scrollAnimationCurve,
        );
      }
    } catch (e) {
      debugPrint('ERROR SCROLLING: $e');
      // Do not scroll to bottom as fallback - this causes the double-scroll issue
    }
  }

  /// Scrolls to the bottom of the message list
  void scrollToBottom([
    Duration? duration,
    Curve curve = Curves.easeOut,
  ]) {
    if (_scrollController?.hasClients != true) return;

    // Don't interrupt user's manual scrolling
    if (_isManuallyScrolling) {
      debugPrint('SCROLL BOTTOM CANCELED: User is manually scrolling');
      return;
    }

    try {
      if (paginationConfig.reverseOrder) {
        // In reverse mode, "bottom" is actually the top (0.0)
        _scrollController!.animateTo(
          0.0,
          duration: duration ?? const Duration(milliseconds: 300),
          curve: curve,
        );
      } else {
        // In chronological mode, bottom is maxScrollExtent
        _scrollController!.animateTo(
          _scrollController!.position.maxScrollExtent,
          duration: duration ?? const Duration(milliseconds: 300),
          curve: curve,
        );
      }
    } catch (e) {
      // If we get an error (eg. because widget is disposing), just ignore it
      // This prevents errors when scrolling during state changes
    }
  }

  /// Adds multiple messages to the chat at once.
  ///
  /// In reverse order mode, the expected behavior with pagination is:
  /// - Newest messages (initial) appear at the top of the list (index 0)
  /// - When loading more messages, older ones appear at the bottom
  ///
  /// In chronological order mode:
  /// - Oldest messages (initial) appear at the top of the list (index 0)
  /// - When loading more messages, newer ones appear at the bottom
  void addMessages(List<ChatMessage> messages) {
    var hasNewMessages = false;

    for (final message in messages) {
      final messageId = _getMessageId(message);
      if (!_messageCache.containsKey(messageId)) {
        // For pagination, we always append at the end regardless of order mode
        // This is appropriate for loading older messages in both modes
        _messages.add(message);
        _messageCache[messageId] = message;
        hasNewMessages = true;
      }
    }

    if (hasNewMessages) {
      notifyListeners();
    }
  }

  /// Updates an existing message or adds it if not found.
  ///
  /// Useful for updating streaming messages or editing existing ones.
  void updateMessage(final ChatMessage message) {
    try {
      // Get the message ID - first from customProperties, then calculate if not present
      final customId = message.customProperties?['id'] as String?;
      final messageId = customId ?? _getMessageId(message);

      // Check if the message exists
      final index = _messages.indexWhere(
        (final msg) => _getMessageId(msg) == messageId,
      );

      final isStreaming =
          message.customProperties?['isStreaming'] as bool? ?? false;

      // Check if this is a user message
      final isUserMessage =
          message.customProperties?['isUserMessage'] as bool? ??
              message.customProperties?['source'] == 'user';

      // When updating streaming messages, make sure we maintain proper state transitions
      if (index != -1 && isStreaming) {
        // For streaming messages, preserve the original streaming state if present
        final existingIsStreaming =
            _messages[index].customProperties?['isStreaming'] as bool? ?? false;

        // Only override the streaming state if explicitly set to false (indicating end of stream)
        if (existingIsStreaming && isStreaming) {
          // Keep streaming active - preserve existing ID and streaming flag
          _messages[index] = message;
          _messageCache[messageId] = message;
        } else {
          // End of streaming or non-streaming update - regular update
          _messages[index] = message;
          _messageCache[messageId] = message;
        }
      } else if (index != -1) {
        // Regular non-streaming message update
        _messages[index] = message;
        _messageCache[messageId] = message;
      } else {
        // Add new message if not found - respecting list order
        if (paginationConfig.reverseOrder) {
          _messages.insert(0, message);
        } else {
          _messages.add(message);
        }
        _messageCache[messageId] = message;
      }

      // Notify listeners about the change
      notifyListeners();

      // Only scroll if configured to do so for updates
      final config = scrollBehaviorConfig;
      bool shouldScroll = false;

      switch (config.autoScrollBehavior) {
        case AutoScrollBehavior.always:
          shouldScroll = true;
          break;
        case AutoScrollBehavior.onNewMessage:
          shouldScroll = index == -1; // Only scroll if it's a new message
          break;
        case AutoScrollBehavior.onUserMessageOnly:
          shouldScroll = isUserMessage;
          break;
        case AutoScrollBehavior.never:
          shouldScroll = false;
          break;
      }

      if (shouldScroll) {
        _scrollAfterRender(isUserMessage, false, config);
      }
    } catch (e) {
      debugPrint('Error updating message: $e');
      // If updating fails, try to add as a new message instead
      try {
        final newId =
            '${message.user.id}_${DateTime.now().millisecondsSinceEpoch}_${message.text.hashCode}';
        final messageWithId = ChatMessage(
          text: message.text,
          user: message.user,
          createdAt: message.createdAt,
          isMarkdown: message.isMarkdown,
          customProperties: {...?message.customProperties, 'id': newId},
        );

        if (paginationConfig.reverseOrder) {
          _messages.insert(0, messageWithId);
        } else {
          _messages.add(messageWithId);
        }
        _messageCache[newId] = messageWithId;
        notifyListeners();

        // Only scroll if configured to do so for new messages
        final config = scrollBehaviorConfig;
        bool shouldScroll = false;

        switch (config.autoScrollBehavior) {
          case AutoScrollBehavior.always:
          case AutoScrollBehavior.onNewMessage:
            shouldScroll = true;
            break;
          case AutoScrollBehavior.onUserMessageOnly:
            final isUserMessage =
                message.customProperties?['isUserMessage'] as bool? ??
                    message.customProperties?['source'] == 'user';
            shouldScroll = isUserMessage;
            break;
          case AutoScrollBehavior.never:
            shouldScroll = false;
            break;
        }

        if (shouldScroll) {
          _scrollAfterRender(false, false, config);
        }
      } catch (fallbackError) {
        debugPrint('Failed to add message as fallback: $fallbackError');
      }
    }
  }

  /// Replaces all existing messages with a new list.
  void setMessages(List<ChatMessage> messages) {
    // Make a defensive copy of the messages
    _messages = List<ChatMessage>.from(messages);

    // Ensure the ordering is correct based on pagination configuration
    if (paginationConfig.reverseOrder) {
      // For reverse mode, sort by newest first
      // With ListView.builder(reverse: true), newest messages will appear at the bottom
      _messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      // For chronological mode, sort by oldest first
      // With ListView.builder(reverse: false), newest messages will appear at the bottom
      _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    _messageCache = {for (var m in _messages) _getMessageId(m): m};
    _currentPage = 1;
    notifyListeners();

    // Only scroll to bottom if configured to do so
    final config = scrollBehaviorConfig;

    if (_messages.isNotEmpty &&
        config.autoScrollBehavior != AutoScrollBehavior.never) {
      final isUserMessage = false; // Default assumption
      _scrollAfterRender(isUserMessage, false, config);
    }
  }

  /// Clears all messages and shows the welcome message.
  void clearMessages() {
    _messages.clear();
    _messageCache.clear();
    _currentPage = 1;
    _hasMoreMessages = true;
    notifyListeners();
  }

  /// Loads more messages using the provided callback.
  ///
  /// Returns early if already loading or no more messages.
  /// The callback should return a list of messages to add.
  Future<void> loadMore(
      Future<List<ChatMessage>> Function()? loadCallback) async {
    if (_isLoadingMore || !_hasMoreMessages || !paginationConfig.enabled) {
      return;
    }

    try {
      _isLoadingMore = true;
      notifyListeners();

      // Simulate network delay if specified
      if (paginationConfig.loadingDelay.inMilliseconds > 0) {
        await Future<void>.delayed(paginationConfig.loadingDelay);
      }

      // Get more messages from the callback or use the backward compatibility one
      final List<ChatMessage> moreMessages;
      if (loadCallback != null) {
        moreMessages = await loadCallback();
      } else if (_onLoadMoreMessagesCallback != null) {
        // Use the last message as a reference for pagination
        final lastMessage = _messages.isNotEmpty ? _messages.last : null;
        moreMessages = await _onLoadMoreMessagesCallback!(lastMessage);
      } else {
        moreMessages = [];
      }

      if (moreMessages.isEmpty) {
        _hasMoreMessages = false;
      } else {
        // Add the messages
        addMessages(moreMessages);
        _currentPage++;
      }
    } catch (e) {
      _hasMoreMessages = true; // Allow retry on error
      rethrow;
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Resets pagination state
  void resetPagination() {
    _hasMoreMessages = true;
    _currentPage = 1;
    notifyListeners();
  }

  /// Handles an example question by creating and adding appropriate messages.
  void handleExampleQuestion(
      String question, ChatUser currentUser, ChatUser aiUser) {
    hideWelcomeMessage();
    addMessage(
      ChatMessage(
        text: question,
        user: currentUser,
        createdAt: DateTime.now(),
      ),
    );
  }

  void hideWelcomeMessage() {
    _showWelcomeMessage = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _messages.clear();
    _messageCache.clear();
    super.dispose();
  }
}
