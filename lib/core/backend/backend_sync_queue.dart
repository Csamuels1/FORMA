class BackendQueuedWrite {
  const BackendQueuedWrite({
    required this.kind,
    required this.entityId,
    required this.payload,
    required this.createdAtIso,
  });

  final String kind;
  final String entityId;
  final Map<String, dynamic> payload;
  final String createdAtIso;

  Map<String, dynamic> toJson() {
    return {
      'kind': kind,
      'entityId': entityId,
      'payload': payload,
      'createdAtIso': createdAtIso,
    };
  }
}

class BackendSyncQueue {
  final List<BackendQueuedWrite> _pending = <BackendQueuedWrite>[];

  int get pendingCount => _pending.length;

  bool get isEmpty => _pending.isEmpty;

  void enqueue(BackendQueuedWrite write) {
    _pending.add(write);
  }

  List<BackendQueuedWrite> drain() {
    final pending = List<BackendQueuedWrite>.from(_pending);
    _pending.clear();
    return pending;
  }
}
