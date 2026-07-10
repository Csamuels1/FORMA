import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/forma_page_shell.dart';
import '../../../core/widgets/forma_section_card.dart';
import '../application/nutrition_controller.dart';
import '../domain/nutrition_entry.dart';
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

          final summaryCard = FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: _NutritionSummary(state: state),
          );
          final logCard = FormaSectionCard(
            padding: const EdgeInsets.all(28),
            child: _MealLogPanel(
              state: state,
              onAddSuggestedMeal: () =>
                  controller.addMeal(state.suggestions.first),
              onAddBalancedMeal: () =>
                  controller.addMeal('Chicken, rice, and vegetables'),
              onSetNigeria: () => controller.setRegion('Nigeria'),
              onSetKenya: () => controller.setRegion('Kenya'),
            ),
          );

          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: summaryCard),
                const SizedBox(width: 18),
                Expanded(flex: 6, child: logCard),
              ],
            );
          }

          return Column(
            children: [
              summaryCard,
              const SizedBox(height: 18),
              logCard,
            ],
          );
        },
      ),
    );
  }
}

class _NutritionSummary extends StatelessWidget {
  const _NutritionSummary({required this.state});

  final NutritionState state;

  @override
  Widget build(BuildContext context) {
    final targets = state.targets;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .primaryContainer
                .withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Daily nutrition',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(
                'The day view stays simple: a target, a live log, and meals that are appropriate for the selected region.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _ProgressCard(
          label: 'Calories',
          consumed: state.consumedCalories,
          target: targets.calories,
          detail: '${state.remainingCalories} kcal remaining',
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 640;
            final crossAxisCount = wide ? 2 : 1;

            return GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: wide ? 2.4 : 3.2,
              children: [
                _MacroTile(
                    label: 'Protein',
                    value:
                        '${state.consumedProteinGrams}/${targets.proteinGrams} g'),
                _MacroTile(
                    label: 'Carbs',
                    value:
                        '${state.consumedCarbsGrams}/${targets.carbsGrams} g'),
                _MacroTile(
                    label: 'Fat',
                    value: '${state.consumedFatGrams}/${targets.fatGrams} g'),
                _MacroTile(label: 'Region', value: state.region),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        FormaSectionCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Suggested meals',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(
                'These are local-first suggestions that stay tied to the selected region.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: state.suggestions
                    .map(
                      (meal) => Chip(
                        avatar: const Icon(Icons.restaurant_outlined, size: 18),
                        label: Text(meal),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MealLogPanel extends StatelessWidget {
  const _MealLogPanel({
    required this.state,
    required this.onAddSuggestedMeal,
    required this.onAddBalancedMeal,
    required this.onSetNigeria,
    required this.onSetKenya,
  });

  final NutritionState state;
  final VoidCallback onAddSuggestedMeal;
  final VoidCallback onAddBalancedMeal;
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
          state.mealLog.isEmpty
              ? 'No meals logged yet. Add a meal to start tracking this session.'
              : '${state.mealLog.length} meal${state.mealLog.length == 1 ? '' : 's'} logged today',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 18),
        if (state.mealLog.isEmpty)
          const _EmptyMealState()
        else
          Column(
            children: state.mealLog
                .map(
                  (meal) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _MealCard(meal: meal),
                  ),
                )
                .toList(),
          ),
        const SizedBox(height: 18),
        FormaSectionCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quick actions',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: onAddBalancedMeal,
                      child: const Text('Add balanced meal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onAddSuggestedMeal,
                      child: const Text('Add suggestion'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  OutlinedButton(
                    onPressed: onSetNigeria,
                    child: const Text('Nigeria'),
                  ),
                  OutlinedButton(
                    onPressed: onSetKenya,
                    child: const Text('Kenya'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.label,
    required this.consumed,
    required this.target,
    required this.detail,
  });

  final String label;
  final int consumed;
  final int target;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final progress = target == 0 ? 0.0 : consumed / target;

    return FormaSectionCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleLarge),
              Text('$consumed / $target',
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(value: progress, minHeight: 10),
          ),
          const SizedBox(height: 10),
          Text(detail, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _MacroTile extends StatelessWidget {
  const _MacroTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant
              .withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({required this.meal});

  final NutritionEntry meal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(meal.label, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(meal.note, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _MacroChip(label: '${meal.calories} kcal'),
              _MacroChip(label: '${meal.proteinGrams}g protein'),
              _MacroChip(label: '${meal.carbsGrams}g carbs'),
              _MacroChip(label: '${meal.fatGrams}g fat'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  const _MacroChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}

class _EmptyMealState extends StatelessWidget {
  const _EmptyMealState();

  @override
  Widget build(BuildContext context) {
    return FormaSectionCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('No meal entries yet',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Start with a suggested meal or a balanced plate to populate the log.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
