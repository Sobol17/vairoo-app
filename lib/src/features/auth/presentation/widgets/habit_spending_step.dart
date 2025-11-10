import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HabitSpendingStep extends StatefulWidget {
  const HabitSpendingStep({
    super.key,
    required this.isLoading,
    required this.onSubmit,
    required this.onSkip,
    this.initialValue,
  });

  final bool isLoading;
  final ValueChanged<String> onSubmit;
  final VoidCallback onSkip;
  final String? initialValue;

  @override
  State<HabitSpendingStep> createState() => _HabitSpendingStepState();
}

class _HabitSpendingStepState extends State<HabitSpendingStep> {
  late final TextEditingController _controller;
  String _currentValue = '';

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue?.trim() ?? '';
    _controller = TextEditingController(text: _currentValue);
    _controller.addListener(_handleTextChanged);
  }

  @override
  void didUpdateWidget(covariant HabitSpendingStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newValue = widget.initialValue?.trim() ?? '';
    if (oldWidget.initialValue != widget.initialValue &&
        newValue != _currentValue) {
      _currentValue = newValue;
      _controller
        ..removeListener(_handleTextChanged)
        ..text = newValue
        ..selection = TextSelection.collapsed(offset: newValue.length)
        ..addListener(_handleTextChanged);
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleTextChanged)
      ..dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    final next = _controller.text;
    if (next == _currentValue) {
      return;
    }
    setState(() {
      _currentValue = next;
    });
  }

  bool get _canSubmit => _currentValue.trim().isNotEmpty && !widget.isLoading;

  void _handleSubmit() {
    if (!_canSubmit) {
      return;
    }
    widget.onSubmit(_currentValue.trim());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryText = theme.textTheme.bodyMedium?.copyWith(
      color: AppColors.primary,
      height: 1.25,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Траты на старую привычку',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Это поможет узнать, сколько денег\nпринесет вам отказ?',
          textAlign: TextAlign.center,
          style: secondaryText,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _controller,
          enabled: !widget.isLoading,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
          ],
          decoration: const InputDecoration(
            hintText: '230',
            hintStyle: TextStyle(color: AppColors.textGray),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Рублей/день',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Transform.scale(
          scale: 1.3,
          child: SvgPicture.asset(
            'assets/icons/habit_illustration.svg',
            height: 380,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: widget.isLoading ? null : widget.onSkip,
          child: const Text(
            'Заполнить позже',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          label: 'Выбрать',
          onPressed: _canSubmit ? _handleSubmit : null,
          isLoading: widget.isLoading,
        ),
      ],
    );
  }
}
