# Linear Design System Guide

## 🎯 **Overview**

The Flutter Gen AI Chat UI package includes a comprehensive **Linear Design System** that ensures consistent, beautiful scaling from mobile to desktop. This system provides mathematically-derived design tokens that scale linearly between breakpoints, maintaining perfect proportions at every screen size.

## ✨ **Key Features**

- **📐 Linear Scaling**: Smooth mathematical progression from mobile (360px) to desktop (1920px)
- **📱 Responsive Breakpoints**: Mobile, Large Mobile, Tablet, Desktop with specific optimizations
- **🎨 Component System**: Pre-built chat components that adapt automatically
- **⚡ Performance Optimized**: Efficient calculations with minimal overhead
- **♿ Accessibility Ready**: WCAG-compliant touch targets and contrast ratios
- **🎭 Platform Aware**: iOS, Android, and Desktop specific adaptations

## 📊 **Breakpoint System**

```dart
Mobile:       360px - 427px  (Scale: 1.0x)
Large Mobile: 428px - 767px  (Scale: 1.1x)
Tablet:       768px - 1439px (Scale: 1.2x)
Desktop:      1440px+        (Scale: 1.4x)
```

## 🚀 **Quick Start**

### 1. Import the Design System
```dart
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
```

### 2. Basic Usage
```dart
class MyResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get responsive dimensions
    final dimensions = LinearDesignGuidelines.getComponentDimensions(context);
    final spacing = LinearDesignGuidelines.getSpacing(context, SpacingSize.md);
    final textStyle = LinearDesignGuidelines.getTextStyle(context, TextStyleType.bodyMedium);

    return Container(
      padding: EdgeInsets.all(spacing),
      constraints: BoxConstraints(maxWidth: dimensions.messageMaxWidth),
      child: Text('Responsive text!', style: textStyle),
    );
  }
}
```

### 3. Interactive Demo
Run the example app and navigate to **"Linear Design System"** to see the interactive demo with:
- Real-time screen width simulation
- Live design specifications
- Responsive component showcase
- Touch target demonstrations

## 📐 **Core APIs**

### **ComponentDimensions**
Get adaptive sizing for UI components:

```dart
final dimensions = LinearDesignGuidelines.getComponentDimensions(context);

// Message bubbles
dimensions.messageMaxWidth      // 85% mobile → 50% desktop (max 800px)
dimensions.messageMinHeight     // 44px scaled
dimensions.messagePadding       // 16x12 scaled

// Buttons and inputs
dimensions.buttonHeight         // 44px+ WCAG compliant
dimensions.inputFieldHeight     // Scaled for comfortable typing
dimensions.borderRadius         // Platform-appropriate rounding

// Avatars
dimensions.avatarSize          // Default avatar (40px scaled)
dimensions.avatarSmall         // Compact avatar (32px scaled) 
dimensions.avatarLarge         // Prominent avatar (56px scaled)
```

### **Spacing System**
Consistent spacing that scales proportionally:

```dart
final spacing = LinearDesignGuidelines.getSpacing(context, SpacingSize.md);

// Available sizes (base values, auto-scaled):
SpacingSize.xs    // 4px
SpacingSize.sm    // 8px  
SpacingSize.md    // 16px
SpacingSize.lg    // 24px
SpacingSize.xl    // 32px
SpacingSize.xxl   // 48px
```

### **Typography System**
Responsive text that maintains readability:

```dart
final textStyle = LinearDesignGuidelines.getTextStyle(context, TextStyleType.bodyMedium);

// Available styles (Material Design 3 compliant):
TextStyleType.displayLarge     // 32px+ for hero text
TextStyleType.headlineMedium   // 20px+ for section titles  
TextStyleType.titleLarge       // 16px+ for card titles
TextStyleType.bodyMedium       // 14px+ for content text
TextStyleType.labelSmall       // 10px+ for captions
```

### **Layout Configuration**
Adaptive layout behavior:

```dart
final layout = LinearDesignGuidelines.getLayoutConfiguration(context);

// Grid system
layout.gridColumns        // 4 mobile → 12 desktop
layout.gridGutter         // Responsive spacing

// Sidebar behavior  
layout.sidebarWidth       // 0 mobile → 320px desktop
layout.showSidebar        // false mobile, true tablet+
layout.useDrawer          // true mobile, false desktop
layout.stackVertically    // Layout orientation

// Container constraints
layout.maxContentWidth    // Readable content width
layout.containerPadding   // Edge-to-edge spacing
```

### **Interaction Specifications**
Platform-appropriate interactions:

```dart
final interaction = LinearDesignGuidelines.getInteractionSpecs(context);

// Touch targets (WCAG compliant)
interaction.minTouchTarget     // 44px minimum
interaction.buttonTouchTarget  // Scaled appropriately
interaction.iconTouchTarget    // Accessible icon sizing

// Hover effects (desktop only)
interaction.enableHover        // false mobile, true desktop
interaction.hoverElevation     // Subtle elevation
interaction.hoverScale         // 1.02x growth

// Animation timing
interaction.quickTransition    // 150ms for immediate feedback
interaction.standardTransition // 250ms for state changes  
interaction.slowTransition     // 350ms for complex animations

// Focus indicators
interaction.focusRingWidth     // Keyboard navigation
interaction.focusRingOffset    // Ring positioning
```

## 🧩 **Pre-built Components**

### **LinearChatMessage**
Auto-scaling message bubbles:

```dart
LinearChatMessage(
  message: 'Hello! I scale perfectly across all devices.',
  isUser: false,
  userName: 'AI Assistant',
  timestamp: DateTime.now(),
)
```

**Features:**
- ✅ Automatic width constraints (85% mobile → 50% desktop)
- ✅ Responsive padding and font sizes
- ✅ Platform-appropriate border radius
- ✅ Avatar sizing with fallback initials
- ✅ Timestamp formatting with relative dates

### **LinearChatInput**
Adaptive input field:

```dart
LinearChatInput(
  controller: _textController,
  onSend: () => _handleSend(),
  onAttach: () => _handleAttach(),
  hintText: 'Type your message...',
)
```

**Features:**
- ✅ WCAG-compliant touch targets
- ✅ Multi-line text expansion
- ✅ Responsive button sizing
- ✅ Platform-specific styling
- ✅ Accessible interaction feedback

### **LinearChatHeader**
Smart header with adaptive layout:

```dart
LinearChatHeader(
  title: 'AI Assistant',
  subtitle: 'Online • Responds instantly',
  avatarUrl: 'https://example.com/avatar.jpg',
  onBackPressed: () => Navigator.pop(context),
  actions: [
    IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
  ],
)
```

**Features:**
- ✅ Responsive avatar sizes
- ✅ Adaptive information density
- ✅ Mobile-first navigation (back button on mobile)
- ✅ Overflow-safe text handling
- ✅ Platform-appropriate spacing

## 📱 **Platform Adaptations**

### **iOS Styling**
```dart
// Automatically applied on iOS devices:
- Rounded corners: 20px
- Button style: No elevation, rounded
- Input style: Filled background, no borders
- Loading: Cupertino-style indicators
```

### **Android Styling**  
```dart
// Automatically applied on Android devices:
- Rounded corners: 16px
- Button style: Material elevation
- Input style: Outlined with focus states
- Loading: Material progress indicators
```

### **Desktop Styling**
```dart
// Automatically applied on desktop platforms:
- Rounded corners: 8px (professional)
- Button style: Subtle elevation with hover
- Input style: Clear borders, focus rings
- Loading: Smaller, refined indicators
```

## 🎨 **Advanced Usage**

### **Custom Scaling**
Create your own scaled components:

```dart
class MyScaledWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Get the current scale factor
    final scaleFactor = _calculateScaleFactor(screenWidth);
    
    return Container(
      width: 100 * scaleFactor,      // Scales: 100px → 140px
      height: 50 * scaleFactor,      // Scales: 50px → 70px  
      padding: EdgeInsets.all(8 * scaleFactor), // Scales: 8px → 11.2px
      child: Text('Scaled content'),
    );
  }
  
  double _calculateScaleFactor(double screenWidth) {
    final clampedWidth = screenWidth.clamp(360.0, 1920.0);
    final progress = (clampedWidth - 360) / (1440 - 360);
    return (1.0 + (progress * 0.4)).clamp(1.0, 1.4);
  }
}
```

### **Device-Aware Layouts**
Adapt layout structure based on device capabilities:

```dart
class AdaptiveLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final layout = LinearDesignGuidelines.getLayoutConfiguration(context);
    
    if (layout.stackVertically) {
      // Mobile: Single column
      return Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
          _buildInput(),
        ],
      );
    } else {
      // Desktop: Sidebar layout
      return Row(
        children: [
          if (layout.showSidebar) SizedBox(
            width: layout.sidebarWidth,
            child: _buildSidebar(),
          ),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildContent()),
                _buildInput(),
              ],
            ),
          ),
        ],
      );
    }
  }
}
```

### **Action Sheets & Modals**
Platform-appropriate presentations:

```dart
// Automatically adapts: Bottom sheet on mobile, Dialog on desktop
final result = await LinearActionSheet.show<String>(
  context: context,
  title: 'Choose an option',
  message: 'This will adapt its presentation style automatically.',
  actions: [
    LinearActionSheetAction(
      label: 'Option 1',
      value: 'option1',
      icon: Icons.star,
      isDefault: true,
    ),
    LinearActionSheetAction(
      label: 'Delete',
      value: 'delete',
      icon: Icons.delete,
      isDestructive: true,
    ),
  ],
);
```

## ⚡ **Performance Tips**

1. **Cache Calculations**: The system automatically caches scale factors
2. **Use Built-in Components**: Pre-optimized components are more efficient
3. **Avoid Nested Builders**: Get dimensions once at the top level
4. **Platform Checks**: Platform-specific optimizations are automatic

## 🔧 **Debugging & Testing**

### **Debug Mode**
Enable visual debugging to see the scaling in action:

```dart
// Add this to your MaterialApp for development
debugShowCheckedModeBanner: false,
```

### **Testing Across Sizes**  
Use the **Linear Design Showcase** example:

1. Run the example app: `flutter run -d chrome`
2. Navigate to "Linear Design System"
3. Use the width simulator to test all breakpoints
4. Toggle design specifications to see exact values
5. Interact with components to test touch targets

### **Integration Testing**
```dart
// Test responsive behavior in integration tests
testWidgets('Message bubble scales correctly', (tester) async {
  await tester.binding.setSurfaceSize(const Size(360, 800)); // Mobile
  await tester.pumpWidget(MyApp());
  
  final bubble = find.byType(LinearChatMessage);
  final mobileWidth = tester.getSize(bubble.first).width;
  
  await tester.binding.setSurfaceSize(const Size(1440, 900)); // Desktop
  await tester.pumpAndSettle();
  
  final desktopWidth = tester.getSize(bubble.first).width;
  expect(desktopWidth, greaterThan(mobileWidth)); // Should scale up
});
```

## 🎯 **Best Practices**

### **✅ Do's**
- Use the pre-built components when possible
- Get dimensions once and pass them down
- Test across all breakpoints during development
- Follow platform conventions (handled automatically)
- Maintain WCAG touch target minimums (automatic)

### **❌ Don'ts**  
- Hardcode pixel values for responsive components
- Use separate widgets for different screen sizes
- Skip testing on actual devices
- Override accessibility minimums
- Ignore platform-specific behaviors

## 📚 **Examples in Action**

Check out these live examples in the demo app:

1. **Basic Implementation**: See how simple it is to get started
2. **Message Bubbles**: Perfect scaling with readable content
3. **Input Fields**: Comfortable typing on any device
4. **Interactive Demo**: Real-time scaling visualization
5. **Touch Targets**: WCAG-compliant interaction areas
6. **Typography**: Readable text at every size

## 🚀 **Next Steps**

1. **Try the Interactive Demo**: Run the example app and explore the Linear Design System
2. **Implement Your First Component**: Start with `LinearChatMessage`
3. **Test Across Devices**: Use the width simulator and real devices
4. **Customize Further**: Build on the system for your specific needs
5. **Share Feedback**: Help improve the system for everyone

---

The Linear Design System ensures your AI chat interface looks perfect and works flawlessly across all devices, from the smallest mobile phone to the largest desktop monitor. **Every pixel scales, every interaction feels natural, and every user has an optimal experience.**