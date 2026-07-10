enum ProgressEntryKind {
  weight,
  photo,
}

class ProgressEntry {
  const ProgressEntry({
    required this.kind,
    required this.label,
    required this.detail,
  });

  final ProgressEntryKind kind;
  final String label;
  final String detail;
}
