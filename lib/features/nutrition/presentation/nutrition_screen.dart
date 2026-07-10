import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/forma_page_shell.dart';
import '../../../core/widgets/forma_section_card.dart';
import '../application/nutrition_controller.dart';
import '../domain/nutrition_state.dart';

class NutritionScreen extends ConsumerWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nutritionControllerProvider);
    final controller = ref.read(nutritionControllerProvider.notifier);

    return FormaPageShell(
      appBar: AppBar(title: const Text('Nutrition')),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;

          final targetCard = FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: _TargetsView(state: state),
          );
          final logCard = FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: _LogView(
              state: state,
              onAddMeal: () => controller.addMeal('Chicken, rice, and vegetables'),
              onSetNigeria: () => controller.setRegion('Nigeria'),
              onSetKenya: () => controller.setRegion('Kenya'),
            ),
          );

          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: targetCard),
                const SizedBox(width: 18),
                Expanded(child: logCard),
              ],
            );
          }

          return Column(
            children: [
              targetCard,
              const SizedBox(height: 18),
              logCard,
            ],
          );
        },
      ),
    );
  }
}

class _TargetsView extends StatelessWidget {
  const _TargetsView({required this.state});

  final NutritionState state;

  @override
  Widget build(BuildContext context) {
    final targets = state.targets;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Daily targets', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text('Region: ${state.region}', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 20),
        _TargetRow(label: 'Calories', value: '${targets.calories} kcal'),
        _TargetRow(label: 'Protein', value: '${targets.proteinGrams} g'),
        _TargetRow(label: 'Carbs', value: '${targets.carbsGrams} g'),
        _TargetRow(label: 'Fat', value: '${targets.fatGrams} g'),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            Chip(label: Text('Location-aware meals')),
            Chip(label: Text('Logging ready')),
            Chip(label: Text('Ad-safe layout')),
          ],
        ),
        const SizedBox(height: 20),
        Text('Suggestions', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        ...state.suggestions.map(
          (meal) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('- $meal'),
          ),
        ),
      ],
    );
  }
}

class _LogView extends StatelessWidget {
  const _LogView({
    required this.state,
    required this.onAddMeal,
    required this.onSetNigeria,
    required this.onSetKenya,
  });

  final NutritionState state;
  final VoidCallback onAddMeal;
  final VoidCallback onSetNigeria;
  final VoidCallback onSetKenya;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Meal log', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text(
          state.mealLog.isEmpty ? 'No meals logged yet.' : 'Recent meals',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        ...state.mealLog.map(
          (meal) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _MealPill(label: meal),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: onAddMeal,
                child: const Text('Add meal'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: onSetNigeria,
                child: const Text('Nigeria'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: onSetKenya,
          child: const Text('Kenya'),
        ),
      ],
    );
  }
}

class _TargetRow extends StatelessWidget {
  const _TargetRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _MealPill extends StatelessWidget {
  const _MealPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(label),
    );
  }
}
