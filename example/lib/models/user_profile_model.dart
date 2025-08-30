import 'package:flutter/foundation.dart';

/// User profile model for context-aware AI interactions
class UserProfile extends ChangeNotifier {
  String _id;
  String _name;
  String _email;
  String _location;
  String _membershipLevel;
  double _totalSpent;
  List<String> _preferences;
  List<String> _favoriteCategories;
  List<String> _recentPurchases;
  Map<String, dynamic> _metadata;

  UserProfile({
    required String id,
    required String name,
    required String email,
    required String location,
    String membershipLevel = 'Basic',
    double totalSpent = 0.0,
    List<String>? preferences,
    List<String>? favoriteCategories,
    List<String>? recentPurchases,
    Map<String, dynamic>? metadata,
  }) : _id = id,
       _name = name,
       _email = email,
       _location = location,
       _membershipLevel = membershipLevel,
       _totalSpent = totalSpent,
       _preferences = preferences ?? [],
       _favoriteCategories = favoriteCategories ?? [],
       _recentPurchases = recentPurchases ?? [],
       _metadata = metadata ?? {};

  // Getters
  String get id => _id;
  String get name => _name;
  String get email => _email;
  String get location => _location;
  String get membershipLevel => _membershipLevel;
  double get totalSpent => _totalSpent;
  List<String> get preferences => List.unmodifiable(_preferences);
  List<String> get favoriteCategories => List.unmodifiable(_favoriteCategories);
  List<String> get recentPurchases => List.unmodifiable(_recentPurchases);
  Map<String, dynamic> get metadata => Map.unmodifiable(_metadata);

  // Setters with notifications
  set name(String value) {
    if (_name != value) {
      _name = value;
      notifyListeners();
    }
  }

  set email(String value) {
    if (_email != value) {
      _email = value;
      notifyListeners();
    }
  }

  set location(String value) {
    if (_location != value) {
      _location = value;
      notifyListeners();
    }
  }

  /// Add preference
  void addPreference(String preference) {
    if (!_preferences.contains(preference)) {
      _preferences.add(preference);
      notifyListeners();
    }
  }

  /// Remove preference
  void removePreference(String preference) {
    if (_preferences.remove(preference)) {
      notifyListeners();
    }
  }

  /// Update preferences list
  void updatePreferences(List<String> newPreferences) {
    _preferences = List.from(newPreferences);
    notifyListeners();
  }

  /// Set metadata value
  void setMetadata(String key, dynamic value) {
    _metadata[key] = value;
    notifyListeners();
  }

  /// Remove metadata key
  void removeMetadata(String key) {
    if (_metadata.remove(key) != null) {
      notifyListeners();
    }
  }

  /// Clear all metadata
  void clearMetadata() {
    if (_metadata.isNotEmpty) {
      _metadata.clear();
      notifyListeners();
    }
  }

  /// Get user context for AI
  String getContextSummary() {
    final buffer = StringBuffer();
    buffer.writeln('User Profile:');
    buffer.writeln('Name: $_name');
    buffer.writeln('Email: $_email');
    buffer.writeln('Location: $_location');
    
    if (_preferences.isNotEmpty) {
      buffer.writeln('Preferences: ${_preferences.join(', ')}');
    }
    
    if (_metadata.isNotEmpty) {
      buffer.writeln('Additional Info:');
      _metadata.forEach((key, value) {
        buffer.writeln('- $key: $value');
      });
    }
    
    return buffer.toString();
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'email': _email,
      'location': _location,
      'preferences': _preferences,
      'metadata': _metadata,
    };
  }

  /// Create from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? 'unknown',
      name: json['name'] as String,
      email: json['email'] as String,
      location: json['location'] as String,
      membershipLevel: json['membershipLevel'] as String? ?? 'Basic',
      totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0.0,
      preferences: (json['preferences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      favoriteCategories: (json['favoriteCategories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      recentPurchases: (json['recentPurchases'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
    );
  }

  /// Create a copy with updated fields
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? location,
    String? membershipLevel,
    double? totalSpent,
    List<String>? preferences,
    List<String>? favoriteCategories,
    List<String>? recentPurchases,
    Map<String, dynamic>? metadata,
  }) {
    return UserProfile(
      id: id ?? _id,
      name: name ?? _name,
      email: email ?? _email,
      location: location ?? _location,
      membershipLevel: membershipLevel ?? _membershipLevel,
      totalSpent: totalSpent ?? _totalSpent,
      preferences: preferences ?? List.from(_preferences),
      favoriteCategories: favoriteCategories ?? List.from(_favoriteCategories),
      recentPurchases: recentPurchases ?? List.from(_recentPurchases),
      metadata: metadata ?? Map.from(_metadata),
    );
  }

  @override
  String toString() {
    return 'UserProfile(name: $_name, email: $_email, location: $_location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other._name == _name &&
        other._email == _email &&
        other._location == _location &&
        listEquals(other._preferences, _preferences) &&
        mapEquals(other._metadata, _metadata);
  }

  @override
  int get hashCode {
    return Object.hash(
      _name,
      _email,
      _location,
      Object.hashAll(_preferences),
      Object.hashAll(_metadata.keys),
    );
  }

  /// Create a sample user profile for testing
  factory UserProfile.sample() {
    return UserProfile(
      id: 'user_123',
      name: 'John Doe',
      email: 'john.doe@example.com',
      location: 'San Francisco, CA',
      membershipLevel: 'Premium',
      totalSpent: 599.99,
      preferences: ['technology', 'AI', 'programming', 'mobile apps'],
      favoriteCategories: ['Electronics', 'Software', 'Books'],
      recentPurchases: ['Flutter Course', 'MacBook Pro', 'AI Handbook'],
      metadata: {
        'timezone': 'PST',
        'language': 'English',
        'experience_level': 'Advanced',
        'interests': ['Flutter', 'AI/ML', 'Mobile Development'],
      },
    );
  }
}