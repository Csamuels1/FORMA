class AppUser {
  const AppUser({
    required this.id,
    required this.displayName,
    required this.locale,
    required this.region,
    required this.tier,
  });

  final String id;
  final String displayName;
  final String locale;
  final String region;
  final SubscriptionTier tier;
}

enum SubscriptionTier { free, pro }
