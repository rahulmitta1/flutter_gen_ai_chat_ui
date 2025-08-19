import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

/// Context-aware actions for e-commerce demo
class ContextAwareActions {
  /// Get cart summary action
  static AiAction getCartSummary() {
    return AiAction(
      name: 'get_cart_summary',
      description: 'Get current shopping cart summary with items and total',
      parameters: [], // No parameters needed - uses context
      handler: (parameters) async {
        // Simulate API call delay
        await Future.delayed(const Duration(milliseconds: 800));

        // In a real app, this would fetch from the actual cart
        // For demo, we'll return mock data that matches context
        return ActionResult.createSuccess({
          'itemsSummary': '• Wireless Headphones (1x) - \$199.99\n• Programming Book (2x) - \$91.98',
          'total': 291.97,
          'itemCount': 3,
          'categories': ['Electronics', 'Books'],
          'qualifiesForFreeShipping': true,
        });
      },
      render: (context, status, parameters, {result, error}) {
        final theme = Theme.of(context);
        
        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shopping_cart, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Shopping Cart Summary',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                if (status == ActionStatus.executing) ...[
                  const Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Loading cart...'),
                    ],
                  ),
                ] else if (status == ActionStatus.completed && result?.data != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result!.data['itemsSummary'],
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\$${result.data['total']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        if (result.data['qualifiesForFreeShipping'] == true) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'FREE SHIPPING',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Product recommendation action
  static AiAction recommendProducts() {
    return AiAction(
      name: 'recommend_products',
      description: 'Recommend products based on user profile and cart contents',
      parameters: [
        ActionParameter.string(
          name: 'userId',
          description: 'User ID to get recommendations for',
          required: true,
        ),
        ActionParameter.number(
          name: 'limit',
          description: 'Maximum number of recommendations',
          required: false,
          defaultValue: 3,
        ),
      ],
      handler: (parameters) async {
        // Simulate AI recommendation processing
        await Future.delayed(const Duration(seconds: 2));

        final limit = parameters['limit'] as num? ?? 3;
        
        // Mock recommendations based on context
        final recommendations = [
          '🎧 **Bluetooth Speaker** - \$89.99\n   *Perfect companion for your wireless headphones*',
          '📱 **Phone Stand** - \$24.99\n   *Great for reading while using your devices*',
          '💻 **Laptop Sleeve** - \$34.99\n   *Protect your tech investments*',
          '📚 **JavaScript Guide** - \$39.99\n   *Expand your programming knowledge*',
          '🔌 **Wireless Charger** - \$45.99\n   *Convenient charging for your electronics*',
        ].take(limit.toInt()).join('\n\n');

        return ActionResult.createSuccess({
          'recommendations': recommendations,
          'count': limit,
          'basedOn': 'Purchase history, cart contents, and member preferences',
        });
      },
      render: (context, status, parameters, {result, error}) {
        final theme = Theme.of(context);
        
        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.recommend, color: Colors.purple),
                    const SizedBox(width: 8),
                    Text(
                      'Product Recommendations',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                if (status == ActionStatus.executing) ...[
                  const Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Analyzing your preferences...'),
                    ],
                  ),
                ] else if (status == ActionStatus.completed && result?.data != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.purple.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result!.data['recommendations'],
                          style: const TextStyle(height: 1.4),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Based on: ${result.data['basedOn']}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Apply member discount action
  static AiAction applyMemberDiscount() {
    return AiAction(
      name: 'apply_member_discount',
      description: 'Apply membership discount to current cart',
      parameters: [
        ActionParameter.string(
          name: 'membershipLevel',
          description: 'Current membership level',
          required: true,
          enumValues: ['Bronze', 'Silver', 'Gold', 'Platinum'],
        ),
      ],
      handler: (parameters) async {
        await Future.delayed(const Duration(milliseconds: 1200));

        final membershipLevel = parameters['membershipLevel'] as String;
        final originalTotal = 291.97; // Mock cart total
        
        double discountPercentage;
        switch (membershipLevel.toLowerCase()) {
          case 'bronze':
            discountPercentage = 5.0;
            break;
          case 'silver':
            discountPercentage = 10.0;
            break;
          case 'gold':
            discountPercentage = 15.0;
            break;
          case 'platinum':
            discountPercentage = 20.0;
            break;
          default:
            discountPercentage = 0.0;
        }
        
        final discountAmount = originalTotal * (discountPercentage / 100);
        final newTotal = originalTotal - discountAmount;

        return ActionResult.createSuccess({
          'discountPercentage': discountPercentage,
          'discountAmount': discountAmount.toStringAsFixed(2),
          'originalTotal': originalTotal.toStringAsFixed(2),
          'newTotal': newTotal.toStringAsFixed(2),
          'membershipLevel': membershipLevel,
        });
      },
      render: (context, status, parameters, {result, error}) {
        final theme = Theme.of(context);
        
        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.discount, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'Member Discount Applied',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                if (status == ActionStatus.executing) ...[
                  const Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Applying discount...'),
                    ],
                  ),
                ] else if (status == ActionStatus.completed && result?.data != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Original Total:'),
                            Text('\$${result!.data['originalTotal']}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${result.data['membershipLevel']} Discount (${result.data['discountPercentage']}%):'),
                            Text(
                              '-\$${result.data['discountAmount']}',
                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'New Total:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\$${result.data['newTotal']}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
      confirmationConfig: const ActionConfirmationConfig(
        title: 'Apply Member Discount',
        message: 'Apply your membership discount to the current cart?',
        required: true,
      ),
    );
  }

  /// Get order history action
  static AiAction getOrderHistory() {
    return AiAction(
      name: 'get_order_history',
      description: 'Get user order history and past purchases',
      parameters: [
        ActionParameter.string(
          name: 'userId',
          description: 'User ID to get history for',
          required: true,
        ),
        ActionParameter.number(
          name: 'limit',
          description: 'Maximum number of orders to return',
          required: false,
          defaultValue: 5,
        ),
      ],
      handler: (parameters) async {
        await Future.delayed(const Duration(milliseconds: 1000));

        final limit = parameters['limit'] as num? ?? 5;
        
        // Mock order history
        final orders = [
          '📱 **iPhone 15 Pro** - \$999.00 (Oct 15, 2024)',
          '💻 **MacBook Air M2** - \$1,199.00 (Sep 28, 2024)',
          '📚 **The Great Gatsby** - \$12.99 (Sep 20, 2024)',
          '🎧 **AirPods Pro** - \$249.00 (Aug 15, 2024)',
          '📖 **Python Programming Guide** - \$34.99 (Aug 10, 2024)',
        ].take(limit.toInt()).join('\n');

        return ActionResult.createSuccess({
          'orderHistory': orders,
          'totalOrders': limit,
          'timeRange': 'Last 3 months',
        });
      },
      render: (context, status, parameters, {result, error}) {
        final theme = Theme.of(context);
        
        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.history, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      'Order History',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                if (status == ActionStatus.executing) ...[
                  const Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Loading order history...'),
                    ],
                  ),
                ] else if (status == ActionStatus.completed && result?.data != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Purchases (${result!.data['timeRange']}):',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          result.data['orderHistory'],
                          style: const TextStyle(height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Get all actions for the context-aware demo
  static List<AiAction> getAllActions() {
    return [
      getCartSummary(),
      recommendProducts(),
      applyMemberDiscount(),
      getOrderHistory(),
    ];
  }
}