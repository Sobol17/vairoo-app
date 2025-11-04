import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoalStep extends StatefulWidget {
  const GoalStep({
    super.key,
    required this.isLoading,
    required this.onSubmit,
    this.initialGoal,
  });

  final bool isLoading;
  final ValueChanged<String> onSubmit;
  final String? initialGoal;

  @override
  State<GoalStep> createState() => _GoalStepState();
}

enum _GoalOption { reduceConsumption, quit }

class _GoalStepState extends State<GoalStep> {
  _GoalOption? _selectedGoal;

  @override
  void initState() {
    super.initState();
    _selectedGoal = _optionFromLabel(widget.initialGoal);
  }

  @override
  void didUpdateWidget(covariant GoalStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialGoal != widget.initialGoal) {
      final updated = _optionFromLabel(widget.initialGoal);
      if (_selectedGoal != updated) {
        setState(() {
          _selectedGoal = updated;
        });
      }
    }
  }

  void _handleSubmit() {
    final selected = _selectedGoal;
    if (selected == null) {
      return;
    }
    widget.onSubmit(_goalValue(selected));
  }

  void _selectGoal(_GoalOption option) {
    if (widget.isLoading) {
      return;
    }
    setState(() {
      _selectedGoal = option;
    });
  }

  String _goalValue(_GoalOption option) {
    return switch (option) {
      _GoalOption.reduceConsumption => 'Сокращение потребления',
      _GoalOption.quit => 'Полный отказ',
    };
  }

  _GoalOption? _optionFromLabel(String? value) {
    return switch (value) {
      'Сокращение потребления' => _GoalOption.reduceConsumption,
      'Полный отказ' => _GoalOption.quit,
      _ => null,
    };
  }

  Widget _buildGoalTile({required _GoalOption option, required String label}) {
    final theme = Theme.of(context);
    final selected = _selectedGoal == option;
    final backgroundColor = selected
        ? AppColors.secondary.withOpacity(0.25)
        : Colors.white;
    final borderColor = selected ? AppColors.primary : AppColors.secondary;
    final textStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectGoal(option),
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Row(
            children: [
              Expanded(child: Text(label, style: textStyle)),
              const SizedBox(width: 12),
              Icon(
                selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected ? AppColors.primary : AppColors.secondary,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondaryText = theme.textTheme.bodyMedium?.copyWith(
      color: AppColors.textSecondary,
      height: 1.4,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Задайте цель',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Заново открыть, кто ты без алкоголя',
          textAlign: TextAlign.center,
          style: secondaryText,
        ),
        const SizedBox(height: 24),
        _buildGoalTile(
          option: _GoalOption.reduceConsumption,
          label: _goalValue(_GoalOption.reduceConsumption),
        ),
        const SizedBox(height: 12),
        _buildGoalTile(
          option: _GoalOption.quit,
          label: _goalValue(_GoalOption.quit),
        ),
        const Spacer(),
        Transform.scale(
          scale: 1.15,
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/goal_bg.svg',
            fit: BoxFit.fitWidth,
          ),
        ),
        const Spacer(),
        PrimaryButton(
          label: 'Войти',
          onPressed: widget.isLoading || _selectedGoal == null
              ? null
              : _handleSubmit,
          isLoading: widget.isLoading,
        ),
      ],
    );
  }
}
