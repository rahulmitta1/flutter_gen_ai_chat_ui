import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

import 'shopping_cart_model.dart';
import 'user_profile_model.dart';
import 'context_aware_actions.dart';

class ContextAwareExample extends StatefulWidget {
  const ContextAwareExample({super.key});

  @override
  State<ContextAwareExample> createState() => _ContextAwareExampleState();
}

class _ContextAwareExampleState extends State<ContextAwareExample> {
  late ChatMessagesController _controller;
  late ChatUser _currentUser;
  late ChatUser _aiUser;
  late StreamSubscription<ActionEvent> _actionSubscription;
  
  // Application state that AI can observe
  late ValueNotifier<UserProfile> _userProfile;
  late ValueNotifier<ShoppingCart> _shoppingCart;
  late ValueNotifier<String> _currentPage;
  late ValueNotifier<Map<String, dynamic>> _preferences;
  
  @override
  void initState() {
    super.initState();
    
    _controller = ChatMessagesController();
    _currentUser = ChatUser(id: '1', firstName: 'John Doe');
    _aiUser = ChatUser(id: '2', firstName: 'AI Assistant');
    
    // Initialize application state
    _userProfile = ValueNotifier(UserProfile(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      membershipLevel: 'Gold',
      totalSpent: 1250.50,
      favoriteCategories: ['Electronics', 'Books'],
      recentPurchases: [
        'iPhone 15 Pro',
        'MacBook Air M2',
        'The Great Gatsby',
      ],
    ,
      customProperties: {'id': messageId},
    );
    _controller.addMessage(aiMessage);
    
    _shoppingCart = ValueNotifier(ShoppingCart(
      items: [
        CartItem(
          id: '1',
          name: 'Wireless Headphones',
          price: 199.99,
          quantity: 1,
          category: 'Electronics',
        ),
        CartItem(
          id: '2',
          name: 'Programming Book',
          price: 45.99,
          quantity: 2,
          category: 'Books',
        ),
      ],
    ,
      customProperties: {'id': messageId},
    );
    _controller.addMessage(aiMessage);
    
    _currentPage = ValueNotifier('product_catalog');
    
    _preferences = ValueNotifier({
      'currency': 'USD',
      'language': 'en',
      'notifications': true,
      'darkMode': false,
      'autoSave': true,
    });
    
    // Add welcome message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.addMessage(ChatMessage(
        text: 'Hello John! I can see you\'re browsing our electronics section and have some items in your cart. '
              'I\'m here to help with product recommendations, order management, and any questions you might have. '
              'As a Gold member, you qualify for free shipping on orders over \$100!\n\n'
              'Try asking me:\n'
              '• "What\'s in my cart?"\n'
              '• "Recommend similar products"\n'
              '• "Apply my member discount"\n'
              '• "Check my order history"',
        user: _aiUser,
        createdAt: DateTime.now(),
      ,
      customProperties: {'id': messageId},
    );
    _controller.addMessage(aiMessage);
    });
  }

  @override
  void dispose() {
    _actionSubscription.cancel();
    _controller.dispose();
    _userProfile.dispose();
    _shoppingCart.dispose();
    _currentPage.dispose();
    _preferences.dispose();
    super.dispose();
  }

  void _handleSendMessage(ChatMessage message) {
    _controller.addMessage(message);
    
    // Simulate AI processing with context awareness
    _processAIResponse(message.text);
  }

  /// Simulates AI processing that's aware of application context
  void _processAIResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    Timer(const Duration(milliseconds: 800), () async {
      final actionHook = AiActionHook.of(context);
      
      // Let AI decide what to do based on context and message
      if (_shouldCheckCart(lowerMessage)) {
        await _handleCartInquiry(actionHook);
      } else if (_shouldRecommendProducts(lowerMessage)) {
        await _handleProductRecommendation(actionHook);
      } else if (_shouldApplyDiscount(lowerMessage)) {
        await _handleDiscountApplication(actionHook);
      } else if (_shouldCheckOrderHistory(lowerMessage)) {
        await _handleOrderHistoryCheck(actionHook);
      } else {
        // General AI response with context awareness
        await _handleGeneralResponse(actionHook, userMessage);
      }
    });
  }

  bool _shouldCheckCart(String message) {
    return message.contains('cart') || 
           message.contains('basket') ||
           message.contains('items') ||
           message.contains('what do i have');
  }

  bool _shouldRecommendProducts(String message) {
    return message.contains('recommend') || 
           message.contains('suggest') ||
           message.contains('similar') ||
           message.contains('other products');
  }

  bool _shouldApplyDiscount(String message) {
    return message.contains('discount') ||
           message.contains('coupon') ||
           message.contains('member') ||
           message.contains('save money');
  }

  bool _shouldCheckOrderHistory(String message) {
    return message.contains('order') ||
           message.contains('purchase') ||
           message.contains('history') ||
           message.contains('bought before');
  }

  Future<void> _handleCartInquiry(AiActionHook actionHook) async {
    final messageId = 'ctx_${DateTime.now().millisecondsSinceEpoch}';
    final aiMessage = ChatMessage(
      text: 'Let me check your current cart...',
      user: _aiUser,
      createdAt: DateTime.now(),
    ,
      customProperties: {'id': messageId},
    );
    _controller.addMessage(aiMessage);
    
    try {
      final result = await actionHook.executeAction('get_cart_summary', {});
      
      if (result.success) {
        final cartData = result.data as Map<String, dynamic>;
        final responseText = 'Here\'s what\'s in your cart:\n\n'
                           '${cartData['itemsSummary']}\n\n'
                           '**Total: \$${cartData['total']}**\n\n'
                           'As a ${_userProfile.value.membershipLevel} member, you qualify for free shipping! '
                           'Would you like me to apply your member discount or recommend related items?';
        
        _controller.updateMessage(aiMessage.copyWith(message: responseText,
      customProperties: {'id': messageId},
    );
    _controller.addMessage(aiMessage);
      } else {
        _controller.updateMessage(aiMessage.copyWith(message: 'Sorry, I couldn\'t access your cart right now. Please try again.',
      customProperties: {'id': messageId},
    );
    _controller.addMessage(aiMessage);
      }
    } catch (e) {
      _controller.updateMessage(aiMessage.copyWith(message: 'I encountered an error checking your cart. Please try again.',
      customProperties: {'id': messageId},
    );
    _controller.addMessage(aiMessage);
    }
  }

  Future<void> _handleProductRecommendation(AiActionHook actionHook) async {
    final messageId = 'ctx_${DateTime.now().millisecondsSinceEpoch}';
    final aiMessage = ChatMessage(
      text: 'Let me find some great recommendations based on your preferences...',
      user: _aiUser,
      createdAt: DateTime.now(),
    ,
      customProperties: {'id': messageId},
    );
    _controller.addMessage(aiMessage);
    
    try {
      final result = await actionHook.executeAction('recommend_products', {
        'userId': _userProfile.value.id,
        'limit': 3,
      });
      
      if (result.success) {
        final recommendations = result.data as Map<String, dynamic>;
        final responseText = 'Based on your purchase history and current cart, here are my top recommendations:\n\n'
                           '${recommendations['recommendations']}\n\n'
                           'These products are popular with other ${_userProfile.value.membershipLevel} members who bought similar items. '
                           'Would you like to add any of these to your cart?';
        
        _controller.updateMessage(aiMessage.copyWith(message: responseText,
      customProperties: {'id': messageId},
    );
    _controller.addMessage(aiMessage);
      } else {
        _controller.updateMessage(aiMessage.copyWith(message: 'I couldn\'t generate recommendations right now. Please try again.',
      customProperties: {'id': messageId},
    );
    _controller.addMessage(aiMessage);
      }
    } catch (e) {
      _controller.updateMessage(aiMessage.copyWith(message: 'I encountered an error finding recommendations. Please try again.',
      customProperties: {'id': messageId},
    );
    _controller.addMessage(aiMessage);
    }
  }

  Future<void> _handleDiscountApplication(AiActionHook actionHook) async {
    final messageId = 'ctx_${DateTime.now().millisecondsSinceEpoch}';
    final aiMessage = ChatMessage(
      text: 'Let me apply your member discount...',
      user: _aiUser,
      createdAt: DateTime.now(),
    ,
      customProperties: {'id': messageId},
    );
    _controller.addMessage(aiMessage);
    
    try {
      final result = await actionHook.executeAction('apply_member_discount', {
        'membershipLevel': _userProfile.value.membershipLevel,
      });
      
      if (result.success) {
        final discountData = result.data as Map<String, dynamic>;
        final responseText = 'Great news! I\'ve applied your ${_userProfile.value.membershipLevel} member discount:\n\n'
                           '**${discountData['discountPercentage']}% off** = **-\$${discountData['discountAmount']}**\n\n'
                           'Your new total: **\$${discountData['newTotal']}** (was \$${discountData['originalTotal']})\n\n'
                           'Plus you get free shipping! Ready to checkout?';
        
        _controller.updateMessage(aiMessage.copyWith(message: responseText,
      customProperties: {'id': messageId},
    );
    _controller.addMessage(aiMessage);
        
        // Update cart with discount applied
        final updatedCart = _shoppingCart.value.copyWith(
          discountApplied: discountData['discountAmount'],
          discountPercentage: discountData['discountPercentage'],
        );
        _shoppingCart.value = updatedCart;
      } else {
        _controller.updateMessage(aiMessage.copyWith(message: 'I couldn\'t apply the discount right now. Please contact customer service.',
      customProperties: {'id': messageId},
    );
    _controller.addMessage(aiMessage);
      }
    } catch (e) {
      _controller.updateMessage(aiMessage.copyWith(message: 'I encountered an error applying the discount. Please try again.',
      customProperties: {'id': messageId},
    );
    _controller.addMessage(aiMessage);
    }
  }

  Future<void> _handleOrderHistoryCheck(AiActionHook actionHook) async {
    final messageId = 'ctx_${DateTime.now().millisecondsSinceEpoch}';
    final aiMessage = ChatMessage(
      text: 'Let me look up your recent order history...',
      user: _aiUser,
      createdAt: DateTime.now(),
    ,
      customProperties: {'id': messageId},
    );
    _controller.addMessage(aiMessage);
    
    try {
      final result = await actionHook.executeAction('get_order_history', {
        'userId': _userProfile.value.id,
        'limit': 5,
      });
      
      if (result.success) {
        final historyData = result.data as Map<String, dynamic>;
        final responseText = 'Here are your recent purchases:\n\n'
                           '${historyData['orderHistory']}\n\n'
                           'Total spent this year: **\$${_userProfile.value.totalSpent}**\n\n'
                           'Would you like to reorder any of these items or see similar products?';
        
        _controller.updateMessage(aiMessage.copyWith(message: responseText,
      customProperties: {'id': messageId},
    );
    _controller.addMessage(aiMessage);
      } else {
        _controller.updateMessage(aiMessage.copyWith(message: 'I couldn\'t access your order history right now. Please try again.',
      customProperties: {'id': messageId},
    );
    _controller.addMessage(aiMessage);
      }
    } catch (e) {
      _controller.updateMessage(aiMessage.copyWith(message: 'I encountered an error checking your order history. Please try again.',
      customProperties: {'id': messageId},
    );
    _controller.addMessage(aiMessage);
    }
  }

  Future<void> _handleGeneralResponse(AiActionHook actionHook, String userMessage) async {
    // Get enhanced prompt with context
    final enhancedPrompt = actionHook.getEnhancedPrompt(
      'User message: $userMessage',
      contextTypes: [AiContextType.userProfile, AiContextType.applicationState, AiContextType.navigationContext],
      contextPriorities: [AiContextPriority.high, AiContextPriority.critical],
      includeActions: true,
    );
    
    dev.log('Enhanced prompt with context: $enhancedPrompt');
    
    // Simulate AI response based on context
    String response = 'I understand you\'re asking about "$userMessage". ';
    
    // Add context-aware insights
    if (_shoppingCart.value.items.isNotEmpty) {
      response += 'I can see you have ${_shoppingCart.value.items.length} items in your cart. ';
    }
    
    if (_userProfile.value.membershipLevel == 'Gold') {
      response += 'As a Gold member, you have access to exclusive discounts and free shipping. ';
    }
    
    response += 'How else can I help you today?';
    
    _controller.addMessage(ChatMessage(
      text: response,
      user: _aiUser,
      createdAt: DateTime.now(),
    ,
      customProperties: {'id': messageId},
    );
    _controller.addMessage(aiMessage);
  }

  @override
  Widget build(BuildContext context) {
    return AiContextProvider(
      config: AiContextProviderConfig(
        contextConfig: const AiContextConfig(
          enableLogging: true,
          maxContextItems: 50,
        ),
        autoNavigationContext: true,
        autoThemeContext: true,
        customProviders: [
          // Custom context provider for app-specific data
          (context) => AiContextData.custom(
            id: 'app_metadata',
            name: 'App Information',
            data: {
              'version': '1.0.0',
              'environment': 'demo',
              'features': ['shopping', 'recommendations', 'discounts'],
            },
            description: 'Application metadata and features',
            categories: ['app', 'metadata'],
            priority: AiContextPriority.low,
          ),
        ],
      ),
      child: AiActionProvider(
        config: AiActionConfig(
          actions: ContextAwareActions.getAllActions(),
          debug: true,
        ),
        child: Builder(
          builder: (context) {
            // Set up context watchers
            final contextHook = AiContextHook.of(context);
            
            // Watch user profile changes
            contextHook.watchNotifier<UserProfile>(
              contextId: 'user_profile',
              contextName: 'User Profile',
              notifier: _userProfile,
              type: AiContextType.userProfile,
              priority: AiContextPriority.high,
              categories: ['user', 'profile', 'membership'],
              serializer: (profile) => 
                'User: ${profile.name} (${profile.email}), '
                'Membership: ${profile.membershipLevel}, '
                'Total Spent: \$${profile.totalSpent}, '
                'Favorite Categories: ${profile.favoriteCategories.join(', ')}',
            );
            
            // Watch shopping cart changes
            contextHook.watchNotifier<ShoppingCart>(
              contextId: 'shopping_cart',
              contextName: 'Shopping Cart',
              notifier: _shoppingCart,
              type: AiContextType.applicationState,
              priority: AiContextPriority.critical,
              categories: ['cart', 'shopping', 'ecommerce'],
              serializer: (cart) => 
                'Cart: ${cart.items.length} items, '
                'Total: \$${cart.total}, '
                'Items: ${cart.items.map((i) => '${i.name} (\$${i.price})').join(', ')}',
            );
            
            // Watch current page navigation
            contextHook.watchNotifier<String>(
              contextId: 'current_page',
              contextName: 'Current Page',
              notifier: _currentPage,
              type: AiContextType.navigationContext,
              priority: AiContextPriority.high,
              categories: ['navigation', 'page'],
            );
            
            // Watch user preferences
            contextHook.watchNotifier<Map<String, dynamic>>(
              contextId: 'user_preferences',
              contextName: 'User Preferences',
              notifier: _preferences,
              type: AiContextType.userProfile,
              priority: AiContextPriority.normal,
              categories: ['preferences', 'settings'],
              serializer: (prefs) => 
                'Preferences: Currency=${prefs['currency']}, '
                'Language=${prefs['language']}, '
                'Notifications=${prefs['notifications']}, '
                'Dark Mode=${prefs['darkMode']}',
            );
            
            return Scaffold(
              appBar: AppBar(
                title: const Text('Context-Aware AI Chat'),
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                actions: [
                  // Shopping cart icon with badge
                  ValueListenableBuilder<ShoppingCart>(
                    valueListenable: _shoppingCart,
                    builder: (context, cart, _) {
                      return Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_cart),
                            onPressed: () => _showCartDialog(context),
                          ),
                          if (cart.items.isNotEmpty)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 14,
                                  minHeight: 14,
                                ),
                                child: Text(
                                  '${cart.items.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  // Context info button
                  AiContextBuilder(
                    builder: (context, contextHook) {
                      return IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: 'Context Information',
                        onPressed: () => _showContextInfo(context, contextHook),
                      );
                    },
                  ),
                ],
              ),
              body: Column(
                children: [
                  // User info header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: ValueListenableBuilder<UserProfile>(
                      valueListenable: _userProfile,
                      builder: (context, profile, _) {
                        return Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: Text(
                                profile.name.substring(0, 1),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile.name,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${profile.membershipLevel} Member • \$${profile.totalSpent} spent',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            ValueListenableBuilder<ShoppingCart>(
                              valueListenable: _shoppingCart,
                              builder: (context, cart, _) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Cart: \$${cart.total.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSecondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  
                  // Chat interface
                  Expanded(
                    child: AiChatWidget(
                      currentUser: _currentUser,
                      aiUser: _aiUser,
                      controller: _controller,
                      onSendMessage: _handleSendMessage,
                      welcomeMessageConfig: WelcomeMessageConfig(
                        title: 'Smart Shopping Assistant',
                        questionsSectionTitle: 'Try asking me:',
                      ),
                      exampleQuestions: const [
                        ExampleQuestion(question: 'What\'s in my cart?'),
                        ExampleQuestion(question: 'Recommend similar products'),
                        ExampleQuestion(question: 'Apply my member discount'),
                        ExampleQuestion(question: 'Show my order history'),
                      ],
                      inputOptions: const InputOptions(
                        decoration: InputDecoration(
                          hintText: 'Ask about products, orders, discounts...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Shopping Cart'),
        content: ValueListenableBuilder<ShoppingCart>(
          valueListenable: _shoppingCart,
          builder: (context, cart, _) {
            return SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (cart.items.isEmpty)
                    const Text('Your cart is empty')
                  else
                    ...cart.items.map((item) => ListTile(
                          title: Text(item.name),
                          subtitle: Text('Qty: ${item.quantity}'),
                          trailing: Text('\$${item.totalPrice.toStringAsFixed(2)}'),
                        )),
                  if (cart.items.isNotEmpty) ...[
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('\$${cart.total.toStringAsFixed(2)}', 
                             style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showContextInfo(BuildContext context, AiContextHook contextHook) {
    final contextData = contextHook.contextData;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Context Information'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Active Context Items: ${contextData.length}'),
                const SizedBox(height: 16),
                ...contextData.values.map((context) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              context.description,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Type: ${context.type.toString().split('.').last}',
                              style: const TextStyle(fontSize: 10),
                            ),
                            Text(
                              'Priority: ${context.priority.toString().split('.').last}',
                              style: const TextStyle(fontSize: 10),
                            ),
                            if (context.categories.isNotEmpty)
                              Text(
                                'Categories: ${context.categories.join(', ')}',
                                style: const TextStyle(fontSize: 10),
                              ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}