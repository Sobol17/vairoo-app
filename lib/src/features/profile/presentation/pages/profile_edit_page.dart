import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/auth/presentation/widgets/brand_logo.dart';
import 'package:ai_note/src/shared/helpers/formatter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final Formatter _formatter;

  DateTime? _birthDate;

  @override
  void initState() {
    super.initState();
    _formatter = Formatter();
    _nameController = TextEditingController(text: 'Иван Иванович');
    _phoneController = TextEditingController(text: '8 919 123 45-67')
      ..addListener(_handlePhoneChanged);
    _emailController = TextEditingController();
    _birthDate = DateTime(2000, 7, 26);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_handlePhoneChanged);
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handlePhoneChanged() {
    final digits = _extractDigits(_phoneController.text);
    final formatted = _formatter.applyPhoneMask(digits);
    if (_phoneController.text != formatted) {
      _phoneController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  String _extractDigits(String value) {
    final buffer = StringBuffer();
    for (final rune in value.runes) {
      final char = String.fromCharCode(rune);
      if (RegExp(r'\d').hasMatch(char)) {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  Future<void> _selectBirthDate() async {
    final now = DateTime.now();
    final initialDate = _birthDate != null
        ? DateTime(_birthDate!.year, _birthDate!.month, _birthDate!.day)
        : DateTime(now.year - 18, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1940),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  String get _formattedBirthDate {
    final date = _birthDate;
    if (date == null) {
      return 'Добавить';
    }
    return _formatter.formatFullDate(date);
  }

  void _handleContinue() {
    FocusScope.of(context).unfocus();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bodyStyle = theme.textTheme.bodyMedium?.copyWith(
      color: AppColors.textSecondary,
      fontWeight: FontWeight.w500,
    );
    final labelStyle = theme.textTheme.bodyLarge?.copyWith(
      color: AppColors.textBlack,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
    final textStyle = theme.textTheme.bodyLarge?.copyWith(
      color: AppColors.textGray,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );

    return Scaffold(
      backgroundColor: AppColors.bgGray,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 56,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const BrandLogo(color: AppColors.secondary),
                            Positioned(
                              left: -15,
                              top: -8,
                              child: TextButton.icon(
                                onPressed: () => {},
                                icon: const Icon(Icons.chevron_left_rounded),
                                label: const Text('Назад'),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.secondary,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Заполните данные',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Это поможет вам восстановить доступ к приложению,\nв случае взлома',
                        textAlign: TextAlign.center,
                        style: bodyStyle,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Персональная информация',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textGray,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 6),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(child: Text('Имя', style: labelStyle)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text('Иван Иванович', style: textStyle),
                                      const SizedBox(width: 12),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColors.textGray,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: const Divider(
                                height: 1,
                                color: AppColors.textGray,
                              ),
                            ),
                            InkWell(
                              onTap: _selectBirthDate,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Дата рождения',
                                      style: labelStyle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _birthDate != null
                                          ? AppColors.secondary.withValues(
                                              alpha: 0.16,
                                            )
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _formattedBirthDate,
                                      style: bodyStyle?.copyWith(
                                        color: _birthDate != null
                                            ? AppColors.secondary
                                            : AppColors.textGray,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: const Divider(
                                height: 1,
                                color: AppColors.textGray,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Номер телефона',
                                    style: labelStyle,
                                  ),
                                ),

                                Expanded(
                                  child: Row(
                                    children: [
                                      Text('8 919 123 45-67', style: textStyle),
                                      const SizedBox(width: 12),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColors.textGray,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: const Divider(
                                height: 1,
                                color: AppColors.textGray,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text('Почта', style: labelStyle),
                                ),
                                const Spacer(),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text('Добавить', style: textStyle),
                                      const SizedBox(width: 12),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColors.textGray,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(height: 28),
                      Text(
                        'Данные можно изменить или заполнить в профиле',
                        textAlign: TextAlign.center,
                        style: bodyStyle?.copyWith(color: AppColors.textGray),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          textStyle: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: _handleContinue,
                        child: const Text('Продолжить'),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
