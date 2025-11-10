import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ToggleRow extends StatelessWidget {
  const ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.onInfoTap,
    super.key,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback onInfoTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: onInfoTap,
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.info_outline,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          activeTrackColor: AppColors.secondary,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
