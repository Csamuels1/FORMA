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
}
