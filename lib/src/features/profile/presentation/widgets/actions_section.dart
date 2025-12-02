import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActionsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium?.copyWith(
      color: AppColors.secondary,
      fontWeight: FontWeight.w600,
    );
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () {},
            child: Text('Сбросить все данные', style: style),
          ),
          TextButton(
            onPressed: () => context.read<AuthController>().logout(),
            child: Text('Выйти', style: style),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Удалить профиль', style: style),
          ),
        ],
      ),
    );
  }
}
