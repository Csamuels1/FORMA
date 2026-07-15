import '../../features/monetization/domain/monetization_policy.dart';
import '../models/photo_policy.dart';

class BackendPolicySnapshot {
  const BackendPolicySnapshot({
    required this.freeTierAiReadjustmentDays,
    required this.proStreakFreezePerMonth,
    required this.allowDashboardBannerAds,
    required this.allowFeedBannerAds,
    required this.allowBetweenSessionInterstitials,
    required this.photoRetentionDays,
    required this.photoStorageMode,
    required this.photoAnalysisMode,
    required this.requiresPhotoConsentBeforeCapture,
  });

  final int freeTierAiReadjustmentDays;
  final int proStreakFreezePerMonth;
  final bool allowDashboardBannerAds;
  final bool allowFeedBannerAds;
  final bool allowBetweenSessionInterstitials;
  final int photoRetentionDays;
  final PhotoStorageMode photoStorageMode;
  final PhotoAnalysisMode photoAnalysisMode;
  final bool requiresPhotoConsentBeforeCapture;

  factory BackendPolicySnapshot.defaults() {
    return const BackendPolicySnapshot(
      freeTierAiReadjustmentDays: 14,
      proStreakFreezePerMonth: 1,
      allowDashboardBannerAds: true,
      allowFeedBannerAds: true,
      allowBetweenSessionInterstitials: true,
      photoRetentionDays: 30,
      photoStorageMode: PhotoStorageMode.localOnly,
      photoAnalysisMode: PhotoAnalysisMode.onDevice,
      requiresPhotoConsentBeforeCapture: true,
    );
  }

  MonetizationPolicy toMonetizationPolicy() {
    return MonetizationPolicy(
      freeTierAiReadjustmentDays: freeTierAiReadjustmentDays,
      proStreakFreezePerMonth: proStreakFreezePerMonth,
      allowDashboardBannerAds: allowDashboardBannerAds,
      allowFeedBannerAds: allowFeedBannerAds,
      allowBetweenSessionInterstitials: allowBetweenSessionInterstitials,
    );
  }

  PhotoPolicy toPhotoPolicy() {
    return PhotoPolicy(
      storageMode: photoStorageMode,
      retentionDays: photoRetentionDays,
      analysisMode: photoAnalysisMode,
      requiresConsentBeforeCapture: requiresPhotoConsentBeforeCapture,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'freeTierAiReadjustmentDays': freeTierAiReadjustmentDays,
      'proStreakFreezePerMonth': proStreakFreezePerMonth,
      'allowDashboardBannerAds': allowDashboardBannerAds,
      'allowFeedBannerAds': allowFeedBannerAds,
      'allowBetweenSessionInterstitials': allowBetweenSessionInterstitials,
      'photoRetentionDays': photoRetentionDays,
      'photoStorageMode': photoStorageMode.name,
      'photoAnalysisMode': photoAnalysisMode.name,
      'requiresPhotoConsentBeforeCapture': requiresPhotoConsentBeforeCapture,
    };
  }

  factory BackendPolicySnapshot.fromJson(Map<String, dynamic> json) {
    final seed = BackendPolicySnapshot.defaults();
    return BackendPolicySnapshot(
      freeTierAiReadjustmentDays: json['freeTierAiReadjustmentDays'] as int? ??
          seed.freeTierAiReadjustmentDays,
      proStreakFreezePerMonth: json['proStreakFreezePerMonth'] as int? ??
          seed.proStreakFreezePerMonth,
      allowDashboardBannerAds: json['allowDashboardBannerAds'] as bool? ??
          seed.allowDashboardBannerAds,
      allowFeedBannerAds:
          json['allowFeedBannerAds'] as bool? ?? seed.allowFeedBannerAds,
      allowBetweenSessionInterstitials:
          json['allowBetweenSessionInterstitials'] as bool? ??
              seed.allowBetweenSessionInterstitials,
      photoRetentionDays:
          json['photoRetentionDays'] as int? ?? seed.photoRetentionDays,
      photoStorageMode: _photoStorageModeFromName(
        json['photoStorageMode'] as String?,
      ),
      photoAnalysisMode: _photoAnalysisModeFromName(
        json['photoAnalysisMode'] as String?,
      ),
      requiresPhotoConsentBeforeCapture:
          json['requiresPhotoConsentBeforeCapture'] as bool? ??
              seed.requiresPhotoConsentBeforeCapture,
    );
  }
}

PhotoStorageMode _photoStorageModeFromName(String? name) {
  switch (name) {
    case 'cloud':
      return PhotoStorageMode.cloud;
    case 'hybrid':
      return PhotoStorageMode.hybrid;
    case 'localOnly':
    default:
      return PhotoStorageMode.localOnly;
  }
}

PhotoAnalysisMode _photoAnalysisModeFromName(String? name) {
  switch (name) {
    case 'cloudApi':
      return PhotoAnalysisMode.cloudApi;
    case 'hybrid':
      return PhotoAnalysisMode.hybrid;
    case 'onDevice':
    default:
      return PhotoAnalysisMode.onDevice;
  }
}
