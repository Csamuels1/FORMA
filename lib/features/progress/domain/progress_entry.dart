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

  Map<String, dynamic> toJson() {
    return {
      'kind': kind.name,
      'label': label,
      'detail': detail,
    };
  }

  factory ProgressEntry.fromJson(Map<String, dynamic> json) {
    final kindName = json['kind'] as String? ?? ProgressEntryKind.weight.name;
    return ProgressEntry(
      kind: ProgressEntryKind.values.firstWhere(
        (kind) => kind.name == kindName,
        orElse: () => ProgressEntryKind.weight,
      ),
      label: json['label'] as String? ?? '',
      detail: json['detail'] as String? ?? '',
    );
  }
}
