class NutritionEntry {
  const NutritionEntry({
    required this.label,
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.note,
  });

  final String label;
  final int calories;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;
  final String note;

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'calories': calories,
      'proteinGrams': proteinGrams,
      'carbsGrams': carbsGrams,
      'fatGrams': fatGrams,
      'note': note,
    };
  }

  factory NutritionEntry.fromJson(Map<String, dynamic> json) {
    return NutritionEntry(
      label: json['label'] as String? ?? '',
      calories: json['calories'] as int? ?? 0,
      proteinGrams: json['proteinGrams'] as int? ?? 0,
      carbsGrams: json['carbsGrams'] as int? ?? 0,
      fatGrams: json['fatGrams'] as int? ?? 0,
      note: json['note'] as String? ?? '',
    );
  }
}
