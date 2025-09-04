import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import '../models/shopping_cart_model.dart';
import '../models/user_profile_model.dart';

/// Context-aware actions that integrate with user profile and shopping cart
class ContextAwareActions {
  /// Add item to shopping cart
  static AiAction addToCart() {
    return AiAction(
      name: 'add_to_cart',
      description: 'Add an item to the user\'s shopping cart',
      parameters: [
        ActionParameter.string(
          name: 'item_name',
          description: 'Name of the item to add',
          required: true,
        ),
        ActionParameter.number(
          name: 'price',
          description: 'Price of the item',
          required: true,
        ),
        ActionParameter.number(
          name: 'quantity',
          description: 'Quantity to add (default: 1)',
          required: false,
          defaultValue: 1,
        ),
        ActionParameter.string(
          name: 'description',
          description: 'Optional item description',
          required: false,
        ),
      ],
      handler: (parameters) async {
        final itemName = parameters['item_name'] as String;
        final price = (parameters['price'] as num).toDouble();
        final quantity = (parameters['quantity'] as num?)?.toInt() ?? 1;
        final description = parameters['description'] as String?;

        // Create cart item
        final item = CartItem(
          id: 'item_${DateTime.now().millisecondsSinceEpoch}',
          name: itemName,
          price: price,
          quantity: quantity,
          description: description,
        );

        return ActionResult.createSuccess({
          'item': item.toJson(),
          'message':
              'Added $quantity x $itemName to cart (\$${(price * quantity).toStringAsFixed(2)})',
        });
      },
    );
  }

  /// View shopping cart contents
  static AiAction viewCart() {
    return AiAction(
      name: 'view_cart',
      description: 'View all items in the shopping cart',
      parameters: [],
      handler: (parameters) async {
        // This would typically access the cart from context
        // For demo purposes, create a sample cart
        final cart = ShoppingCart();

        if (cart.isEmpty) {
          return ActionResult.createSuccess({
            'message': 'Your shopping cart is empty',
            'items': [],
            'total': 0.0,
          });
        }

        return ActionResult.createSuccess({
          'message': cart.getSummary(),
          'items': cart.items.map((item) => item.toJson()).toList(),
          'total': cart.totalPrice,
          'itemCount': cart.itemCount,
        });
      },
    );
  }

  /// Update user preferences
  static AiAction updateUserPreferences() {
    return AiAction(
      name: 'update_preferences',
      description: 'Update user preferences and interests',
      parameters: [
        ActionParameter.array(
          name: 'preferences',
          description: 'List of user preferences/interests',
          required: true,
        ),
        ActionParameter.string(
          name: 'action',
          description: 'Action to perform: add, remove, or replace',
          required: false,
          defaultValue: 'add',
          enumValues: ['add', 'remove', 'replace'],
        ),
      ],
      handler: (parameters) async {
        final preferences = (parameters['preferences'] as List)
            .map((e) => e.toString())
            .toList();
        final action = parameters['action'] as String? ?? 'add';

        // This would typically update the user profile from context
        final profile = UserProfile.sample();

        switch (action) {
          case 'add':
            for (final pref in preferences) {
              profile.addPreference(pref);
            }
            break;
          case 'remove':
            for (final pref in preferences) {
              profile.removePreference(pref);
            }
            break;
          case 'replace':
            profile.updatePreferences(preferences);
            break;
        }

        return ActionResult.createSuccess({
          'message': 'Updated user preferences',
          'preferences': profile.preferences,
          'action': action,
        });
      },
    );
  }

  /// Get personalized recommendations
  static AiAction getRecommendations() {
    return AiAction(
      name: 'get_recommendations',
      description:
          'Get personalized recommendations based on user profile and preferences',
      parameters: [
        ActionParameter.string(
          name: 'category',
          description:
              'Category for recommendations (e.g., products, content, activities)',
          required: false,
          defaultValue: 'general',
        ),
        ActionParameter.number(
          name: 'count',
          description: 'Number of recommendations to return',
          required: false,
          defaultValue: 5,
        ),
      ],
      handler: (parameters) async {
        final category = parameters['category'] as String? ?? 'general';
        final count = (parameters['count'] as num?)?.toInt() ?? 5;

        // Simulate AI-powered recommendations
        await Future.delayed(const Duration(milliseconds: 800));

        final recommendations = List.generate(count, (index) {
          return {
            'id': 'rec_${index + 1}',
            'title': 'Recommendation ${index + 1} for $category',
            'description':
                'This is a personalized recommendation based on your interests and preferences',
            'category': category,
            'score': 0.8 + (index * 0.02),
            'reason':
                'Based on your interest in ${category == 'general' ? 'technology and AI' : category}',
          };
        });

        return ActionResult.createSuccess({
          'message':
              'Generated $count personalized recommendations for $category',
          'recommendations': recommendations,
          'category': category,
          'total': count,
        });
      },
    );
  }

  /// Set user location and timezone
  static AiAction updateLocation() {
    return AiAction(
      name: 'update_location',
      description: 'Update user\'s location and timezone information',
      parameters: [
        ActionParameter.string(
          name: 'location',
          description: 'User\'s location (city, country)',
          required: true,
        ),
        ActionParameter.string(
          name: 'timezone',
          description: 'User\'s timezone (e.g., PST, GMT)',
          required: false,
        ),
      ],
      handler: (parameters) async {
        final location = parameters['location'] as String;
        final timezone = parameters['timezone'] as String?;

        // This would typically update the user profile
        final profile = UserProfile.sample();
        profile.location = location;

        if (timezone != null) {
          profile.setMetadata('timezone', timezone);
        }

        return ActionResult.createSuccess({
          'message':
              'Updated location to $location${timezone != null ? ' ($timezone)' : ''}',
          'location': location,
          'timezone': timezone,
          'localTime': DateTime.now().toLocal().toString(),
        });
      },
    );
  }

  /// Get user context summary
  static AiAction getUserContext() {
    return AiAction(
      name: 'get_user_context',
      description:
          'Get comprehensive user context including profile and cart information',
      parameters: [],
      handler: (parameters) async {
        // This would typically access actual user data from context
        final profile = UserProfile.sample();
        final cart = ShoppingCart();

        return ActionResult.createSuccess({
          'message': 'Retrieved user context successfully',
          'profile': profile.toJson(),
          'profileSummary': profile.getContextSummary(),
          'cart': {
            'itemCount': cart.itemCount,
            'totalPrice': cart.totalPrice,
            'isEmpty': cart.isEmpty,
          },
          'lastUpdated': DateTime.now().toIso8601String(),
        });
      },
    );
  }

  /// Smart search with user preferences
  static AiAction smartSearch() {
    return AiAction(
      name: 'smart_search',
      description:
          'Perform intelligent search considering user preferences and context',
      parameters: [
        ActionParameter.string(
          name: 'query',
          description: 'Search query',
          required: true,
        ),
        ActionParameter.boolean(
          name: 'use_preferences',
          description: 'Whether to consider user preferences in search',
          required: false,
          defaultValue: true,
        ),
      ],
      handler: (parameters) async {
        final query = parameters['query'] as String;
        final usePreferences = parameters['use_preferences'] as bool? ?? true;

        // Simulate intelligent search
        await Future.delayed(const Duration(milliseconds: 600));

        final profile = UserProfile.sample();
        final results = List.generate(3, (index) {
          return {
            'id': 'result_${index + 1}',
            'title': 'Smart Result ${index + 1} for "$query"',
            'description': usePreferences
                ? 'Result tailored to your interests: ${profile.preferences.take(2).join(', ')}'
                : 'General search result for your query',
            'relevance': 0.9 - (index * 0.1),
            'source': 'AI-powered search',
            'personalized': usePreferences,
          };
        });

        return ActionResult.createSuccess({
          'message': 'Found ${results.length} results for "$query"',
          'query': query,
          'results': results,
          'personalized': usePreferences,
          'searchTime': '${600 + (results.length * 50)}ms',
        });
      },
    );
  }

  /// Get all available context-aware actions
  static List<AiAction> getAllActions() {
    return [
      addToCart(),
      viewCart(),
      updateUserPreferences(),
      getRecommendations(),
      updateLocation(),
      getUserContext(),
      smartSearch(),
    ];
  }
}
