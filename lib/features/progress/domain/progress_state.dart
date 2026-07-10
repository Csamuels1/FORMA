import 'progress_entry.dart';

class ProgressState {
  const ProgressState({
    required this.currentWeightKg,
    required this.entries,
  });

  final double currentWeightKg;
  final List<ProgressEntry> entries;

  factory ProgressState.initial() {
    return const ProgressState(
      currentWeightKg: 94.0,
      entries: [
        ProgressEntry(
          kind: ProgressEntryKind.weight,
          label: '97.2 kg',
          detail: 'Baseline weight sample',
        ),
        ProgressEntry(
          kind: ProgressEntryKind.photo,
          label: 'January check-in',
          detail: 'Front, side, and back photos captured',
        ),
        ProgressEntry(
          kind: ProgressEntryKind.weight,
          label: '95.4 kg',
          detail: 'Down from the first sample',
        ),
        ProgressEntry(
          kind: ProgressEntryKind.photo,
          label: 'February check-in',
          detail: 'Latest monthly photo review',
        ),
        ProgressEntry(
          kind: ProgressEntryKind.weight,
          label: '94.0 kg',
          detail: 'Current running weight',
        ),
      ],
    );
  }

  double get startingWeightKg {
    final firstWeightEntry = entries
            .where((entry) => entry.kind == ProgressEntryKind.weight)
            .isNotEmpty
        ? entries.firstWhere((entry) => entry.kind == ProgressEntryKind.weight)
        : null;

    if (firstWeightEntry == null) {
      return currentWeightKg;
    }

    return double.tryParse(firstWeightEntry.label.replaceAll(' kg', '')) ??
        currentWeightKg;
  }

  double get weightChangeKg => startingWeightKg - currentWeightKg;

  int get weightSampleCount =>
      entries.where((entry) => entry.kind == ProgressEntryKind.weight).length;

  int get photoCheckInCount =>
      entries.where((entry) => entry.kind == ProgressEntryKind.photo).length;

  Map<String, dynamic> toJson() {
    return {
      'currentWeightKg': currentWeightKg,
      'entries': entries.map((entry) => entry.toJson()).toList(),
    };
  }

  factory ProgressState.fromJson(Map<String, dynamic> json) {
    final seed = ProgressState.initial();
    final entriesJson = json['entries'];
    return ProgressState(
      currentWeightKg:
          (json['currentWeightKg'] as num?)?.toDouble() ?? seed.currentWeightKg,
      entries: entriesJson is List
          ? entriesJson
              .whereType<Map>()
              .map((item) =>
                  ProgressEntry.fromJson(item.cast<String, dynamic>()))
              .toList()
          : seed.entries,
    );
  }

  ProgressState copyWith({
    double? currentWeightKg,
    List<ProgressEntry>? entries,
  }) {
    return ProgressState(
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      entries: entries ?? this.entries,
    );
  }
}
