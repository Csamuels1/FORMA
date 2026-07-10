import 'ad_placement.dart';
import 'monetization_policy.dart';

class AdGuard {
  const AdGuard(this.policy);

  final MonetizationPolicy policy;

  bool canShow(AdPlacement placement) {
    switch (placement) {
      case AdPlacement.dashboardBanner:
        return policy.allowDashboardBannerAds;
      case AdPlacement.feedBanner:
        return policy.allowFeedBannerAds;
      case AdPlacement.betweenSessionsInterstitial:
        return policy.allowBetweenSessionInterstitials;
      case AdPlacement.blockedDuringSet:
      case AdPlacement.blockedDuringRestTimer:
      case AdPlacement.blockedDuringPhotoFlow:
        return false;
    }
  }
}
