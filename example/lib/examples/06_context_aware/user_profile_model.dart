/// User profile model for context-aware demo
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String membershipLevel; // Bronze, Silver, Gold, Platinum
  final double totalSpent;
  final List<String> favoriteCategories;
  final List<String> recentPurchases;
  final DateTime? lastLoginDate;
  final Map<String, dynamic>? preferences;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.membershipLevel,
    required this.totalSpent,
    required this.favoriteCategories,
    required this.recentPurchases,
    this.lastLoginDate,
    this.preferences,
  });

  /// Get discount percentage based on membership level
  double get discountPercentage {
    switch (membershipLevel.toLowerCase()) {
      case 'bronze':
        return 5.0;
      case 'silver':
        return 10.0;
      case 'gold':
        return 15.0;
      case 'platinum':
        return 20.0;
      default:
        return 0.0;
    }
  }

  /// Check if user qualifies for free shipping
  bool get qualifiesForFreeShipping {
    return membershipLevel.toLowerCase() != 'bronze';
  }

  /// Get member benefits as a list
  List<String> get memberBenefits {
    switch (membershipLevel.toLowerCase()) {
      case 'bronze':
        return ['5% discount', 'Birthday bonus'];
      case 'silver':
        return ['10% discount', 'Free shipping on \$50+', 'Birthday bonus', 'Early access'];
      case 'gold':
        return ['15% discount', 'Free shipping', 'Birthday bonus', 'Early access', 'Priority support'];
      case 'platinum':
        return ['20% discount', 'Free shipping', 'Birthday bonus', 'Early access', 'Priority support', 'Exclusive deals'];
      default:
        return [];
    }
  }

  /// Copy with new values
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? membershipLevel,
    double? totalSpent,
    List<String>? favoriteCategories,
    List<String>? recentPurchases,
    DateTime? lastLoginDate,
    Map<String, dynamic>? preferences,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      membershipLevel: membershipLevel ?? this.membershipLevel,
      totalSpent: totalSpent ?? this.totalSpent,
      favoriteCategories: favoriteCategories ?? this.favoriteCategories,
      recentPurchases: recentPurchases ?? this.recentPurchases,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      preferences: preferences ?? this.preferences,
    );
  }

  /// Convert to map for context serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'membershipLevel': membershipLevel,
      'totalSpent': totalSpent,
      'favoriteCategories': favoriteCategories,
      'recentPurchases': recentPurchases,
      'discountPercentage': discountPercentage,
      'qualifiesForFreeShipping': qualifiesForFreeShipping,
      'memberBenefits': memberBenefits,
      if (lastLoginDate != null) 'lastLoginDate': lastLoginDate!.toIso8601String(),
      if (preferences != null) 'preferences': preferences,
    };
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, membershipLevel: $membershipLevel, totalSpent: $totalSpent)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}