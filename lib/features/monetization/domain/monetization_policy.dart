class MonetizationPolicy {
  const MonetizationPolicy({
    required this.freeTierAiReadjustmentDays,
    required this.proStreakFreezePerMonth,
    required this.allowDashboardBannerAds,
    required this.allowFeedBannerAds,
    required this.allowBetweenSessionInterstitials,
  });

  final int freeTierAiReadjustmentDays;
  final int proStreakFreezePerMonth;
  final bool allowDashboardBannerAds;
  final bool allowFeedBannerAds;
  final bool allowBetweenSessionInterstitials;

  const MonetizationPolicy.defaults()
      : freeTierAiReadjustmentDays = 14,
        proStreakFreezePerMonth = 1,
        allowDashboardBannerAds = true,
        allowFeedBannerAds = true,
        allowBetweenSessionInterstitials = true;
}
