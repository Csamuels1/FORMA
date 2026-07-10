class PhotoPolicy {
  const PhotoPolicy({
    required this.storageMode,
    required this.retentionDays,
    required this.analysisMode,
    required this.requiresConsentBeforeCapture,
  });

  final PhotoStorageMode storageMode;
  final int retentionDays;
  final PhotoAnalysisMode analysisMode;
  final bool requiresConsentBeforeCapture;
}

enum PhotoStorageMode { localOnly, cloud, hybrid }

enum PhotoAnalysisMode { onDevice, cloudApi, hybrid }
