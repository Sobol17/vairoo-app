import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/home/presentation/widgets/header_circle_button.dart';
import 'package:Vairoo/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:Vairoo/src/features/profile/presentation/controllers/profile_controller.dart';
import 'package:Vairoo/src/features/profile/presentation/widgets/actions_section.dart';
import 'package:Vairoo/src/features/profile/presentation/widgets/notifications_section.dart';
import 'package:Vairoo/src/features/profile/presentation/widgets/profile_info_row.dart';
import 'package:Vairoo/src/features/profile/presentation/widgets/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileController>(
      create: (context) =>
          ProfileController(repository: context.read<ProfileRepository>())
            ..loadProfile(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, controller, _) {
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: AppColors.bgGray,
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            HeaderCircleButton(
                              color: AppColors.surface,
                              icon: SvgPicture.asset(
                                'assets/icons/chat.svg',
                                width: 20,
                              ),
                              onTap: () => context.push('/home/chat'),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Профиль',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Заложите прочный фундамент на день',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            HeaderCircleButton(
                              color: AppColors.surface,
                              icon: SvgPicture.asset(
                                'assets/icons/calendar.svg',
                                width: 20,
                              ),
                              onTap: () => context.push('/calendar'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        CircleAvatar(
                          radius: 64,
                          backgroundColor: AppColors.secondaryLight,
                          child: Image.asset('assets/icons/avatar.png'),
                        ),
                        TextButton(
                          onPressed: () async {
                            final updated = await context.push('/profile/edit');
                            if (updated == true) {
                              // ignore: use_build_context_synchronously
                              await controller.loadProfile();
                            }
                          },
                          child: const Text('Изменить'),
                        ),
                        const SizedBox(height: 16),
                        ProfileSection(
                          title: 'Персональная информация',
                          children: [
                            ProfileInfoRow(
                              label: 'Имя',
                              value: controller.displayName,
                            ),
                            ProfileInfoRow(
                              label: 'Дата рождения',
                              value: controller.birthDateLabel,
                            ),
                            ProfileInfoRow(
                              label: 'Номер телефона',
                              value: controller.phoneLabel,
                            ),
                            ProfileInfoRow(
                              label: 'Почта',
                              value: controller.emailLabel,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ProfileSection(
                          title: 'Статистика улучшений',
                          children: [
                            ProfileInfoRow(
                              label: 'Трезв',
                              value: controller.sobrietyDuration,
                              highlight: true,
                              showChevron: false,
                            ),
                            ProfileInfoRow(
                              label: 'Дата начала трезвости',
                              value: controller.sobrietyStartLabel,
                              highlight: true,
                              showChevron: false,
                            ),
                            ProfileInfoRow(
                              label: 'Затраты в день, в сред.',
                              value: controller.dailyExpensesLabel,
                              highlight: controller.dailyExpenses != null,
                              showChevron: true,
                              onTap: controller.isLoading
                                  ? null
                                  : () => _editDailyExpenses(context, controller),
                            ),
                            ProfileInfoRow(
                              label: 'Ккал в день, в сред.',
                              value: controller.dailyCaloriesLabel,
                              highlight: controller.dailyCalories != null,
                              showChevron: true,
                              onTap: controller.isLoading
                                  ? null
                                  : () => _editDailyCalories(context, controller),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        NotificationsSection(controller: controller),
                        const SizedBox(height: 24),
                        ActionsSection(),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Future<void> _editDailyExpenses(
    BuildContext context,
    ProfileController controller,
  ) {
    return _showMetricInputSheet(
      context: context,
      title: 'Затраты в день',
      hintText: 'Введите сумму в рублях',
      unitSuffix: '₽',
      initialValue: controller.dailyExpenses,
      onSubmit: controller.updateDailyExpenses,
    );
  }

  Future<void> _editDailyCalories(
    BuildContext context,
    ProfileController controller,
  ) {
    return _showMetricInputSheet(
      context: context,
      title: 'Ккал в день',
      hintText: 'Введите количество ккал',
      unitSuffix: 'ккал',
      initialValue: controller.dailyCalories,
      onSubmit: controller.updateDailyCalories,
    );
  }

  Future<void> _showMetricInputSheet({
    required BuildContext context,
    required String title,
    required String hintText,
    required String unitSuffix,
    required double? initialValue,
    required Future<void> Function(double value) onSubmit,
  }) {
    FocusScope.of(context).unfocus();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _MetricInputBottomSheet(
        title: title,
        hintText: hintText,
        unitSuffix: unitSuffix,
        initialValue: initialValue,
        onSubmit: onSubmit,
      ),
    );
  }
}

class _MetricInputBottomSheet extends StatefulWidget {
  const _MetricInputBottomSheet({
    required this.title,
    required this.hintText,
    required this.unitSuffix,
    required this.onSubmit,
    this.initialValue,
  });

  final String title;
  final String hintText;
  final String unitSuffix;
  final double? initialValue;
  final Future<void> Function(double value) onSubmit;

  @override
  State<_MetricInputBottomSheet> createState() =>
      _MetricInputBottomSheetState();
}

class _MetricInputBottomSheetState extends State<_MetricInputBottomSheet> {
  late final TextEditingController _controller;
  bool _isSubmitting = false;
  String? _fieldError;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue == null
          ? ''
          : _formatNumber(widget.initialValue!),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(double value) {
    if (value % 1 == 0) {
      return value.toStringAsFixed(0);
    }
    var text = value.toStringAsFixed(2);
    text = text.replaceAll(RegExp(r'0+$'), '');
    if (text.endsWith('.')) {
      text = text.substring(0, text.length - 1);
    }
    return text;
  }

  Future<void> _handleSubmit() async {
    final raw = _controller.text.trim().replaceAll(',', '.');
    final parsed = double.tryParse(raw);
    if (parsed == null || parsed <= 0) {
      setState(() {
        _fieldError = 'Введите корректное значение';
      });
      return;
    }
    setState(() {
      _fieldError = null;
      _submitError = null;
      _isSubmitting = true;
    });
    try {
      await widget.onSubmit(parsed);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        final message = error.toString();
        _submitError = message.startsWith('Exception: ')
            ? message.substring('Exception: '.length)
            : message;
      });
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.textGray.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                autofocus: true,
                textInputAction: TextInputAction.done,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                onSubmitted: (_) => _handleSubmit(),
                decoration: InputDecoration(
                  labelText: widget.hintText,
                  suffixText: widget.unitSuffix,
                  errorText: _fieldError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              if (_submitError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _submitError!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
