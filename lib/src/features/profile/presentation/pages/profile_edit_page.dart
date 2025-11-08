import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/auth/presentation/widgets/brand_logo.dart';
import 'package:ai_note/src/shared/helpers/formatter.dart';
import 'package:ai_note/src/shared/helpers/phone_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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

  String? _phoneDigits;
  DateTime? _birthDate;

  @override
  void initState() {
    super.initState();
    _formatter = Formatter();
    _nameController = TextEditingController(text: 'Иван Иванович');
    _emailController = TextEditingController();
    _initializePhoneController('8 919 123 45-67');
    _birthDate = DateTime(2000, 7, 26);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _initializePhoneController(String phone) {
    final digits = _prepareDigitsForMask(phone);
    if (digits.isEmpty) {
      _phoneController = TextEditingController();
      _phoneDigits = null;
      return;
    }
    final mask = _createPhoneMask(initialDigits: digits);
    final masked = mask.getMaskedText();
    _phoneDigits = mask.getUnmaskedText();
    _phoneController = TextEditingController(text: masked);
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

  Future<void> _editName() async {
    final result = await _showTextEditBottomSheet(
      title: 'Имя',
      hintText: 'Введите имя',
      initialValue: _nameController.text,
      textCapitalization: TextCapitalization.words,
    );
    if (!mounted) {
      return;
    }
    if (result != null) {
      setState(() {
        _nameController.text = result;
      });
    }
  }

  Future<void> _editPhone() async {
    final digits = _phoneDigits ?? _prepareDigitsForMask(_phoneController.text);
    final mask = _createPhoneMask(
      initialDigits: digits.isEmpty ? null : digits,
    );
    final result = await _showTextEditBottomSheet(
      title: 'Номер телефона',
      hintText: '+7 (___) ___-__-__',
      initialValue: mask.getMaskedText(),
      keyboardType: TextInputType.phone,
      inputFormatters: [mask],
      valueBuilder: (_) => mask.getMaskedText(),
    );
    if (!mounted) {
      return;
    }
    if (result != null) {
      final unmasked = mask.getUnmaskedText();
      setState(() {
        _phoneDigits = unmasked.isEmpty ? null : unmasked;
        _phoneController.text = result;
      });
    }
  }

  Future<void> _editEmail() async {
    final result = await _showTextEditBottomSheet(
      title: 'Электронная почта',
      hintText: 'example@mail.com',
      initialValue: _emailController.text,
      keyboardType: TextInputType.emailAddress,
    );
    if (!mounted) {
      return;
    }
    if (result != null) {
      setState(() {
        _emailController.text = result;
      });
    }
  }

  Future<String?> _showTextEditBottomSheet({
    required String title,
    required String initialValue,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
    String Function(TextEditingController controller)? valueBuilder,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final viewInsets = MediaQuery.of(ctx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: viewInsets),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: _TextEditBottomSheet(
              title: title,
              initialValue: initialValue,
              hintText: hintText,
              keyboardType: keyboardType,
              textCapitalization: textCapitalization,
              inputFormatters: inputFormatters,
              valueBuilder: valueBuilder,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEditableField({
    required VoidCallback onTap,
    required String label,
    required String value,
    required TextStyle? labelStyle,
    required TextStyle? valueStyle,
  }) {
    final displayValue = value.trim().isEmpty ? 'Добавить' : value.trim();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Text(label, style: labelStyle)),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      displayValue,
                      style: valueStyle,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textGray,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  MaskTextInputFormatter _createPhoneMask({String? initialDigits}) {
    return MaskTextInputFormatter(
      mask: phoneMask.getMask(),
      filter: {"#": RegExp(r'[0-9]')},
      type: phoneMask.type,
      initialText: initialDigits,
    );
  }

  String _extractDigits(String input) =>
      input.replaceAll(RegExp(r'[^0-9]'), '');

  String _prepareDigitsForMask(String input) {
    var digits = _extractDigits(input);
    if (digits.isEmpty) {
      return '';
    }
    if (digits.length > 11) {
      digits = digits.substring(digits.length - 11);
    }
    if (digits.length == 11 &&
        (digits.startsWith('7') || digits.startsWith('8'))) {
      digits = digits.substring(1);
    }
    if (digits.length > 10) {
      digits = digits.substring(digits.length - 10);
    }
    return digits;
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
                                onPressed: () => context.push('/profile'),
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
                        margin: const EdgeInsets.only(top: 6),
                        child: Material(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                _buildEditableField(
                                  onTap: _editName,
                                  label: 'Имя',
                                  value: _nameController.text,
                                  labelStyle: labelStyle,
                                  valueStyle: textStyle,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: const Divider(
                                    height: 1,
                                    color: AppColors.textGray,
                                  ),
                                ),
                                InkWell(
                                  onTap: _selectBirthDate,
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
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
                                                ? AppColors.secondary
                                                      .withValues(alpha: 0.16)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: const Divider(
                                    height: 1,
                                    color: AppColors.textGray,
                                  ),
                                ),
                                _buildEditableField(
                                  onTap: _editPhone,
                                  label: 'Номер телефона',
                                  value: _phoneController.text,
                                  labelStyle: labelStyle,
                                  valueStyle: textStyle,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: const Divider(
                                    height: 1,
                                    color: AppColors.textGray,
                                  ),
                                ),
                                _buildEditableField(
                                  onTap: _editEmail,
                                  label: 'Почта',
                                  value: _emailController.text,
                                  labelStyle: labelStyle,
                                  valueStyle: textStyle,
                                ),
                              ],
                            ),
                          ),
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

class _TextEditBottomSheet extends StatefulWidget {
  const _TextEditBottomSheet({
    required this.title,
    required this.initialValue,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.valueBuilder,
  });

  final String title;
  final String initialValue;
  final String? hintText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final String Function(TextEditingController controller)? valueBuilder;

  @override
  State<_TextEditBottomSheet> createState() => _TextEditBottomSheetState();
}

class _TextEditBottomSheetState extends State<_TextEditBottomSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.selection = TextSelection.collapsed(
      offset: widget.initialValue.length,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textBlack,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                autofocus: true,
                keyboardType: widget.keyboardType,
                textCapitalization: widget.textCapitalization,
                textInputAction: TextInputAction.done,
                inputFormatters: widget.inputFormatters,
                decoration: InputDecoration(hintText: widget.hintText),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  final value =
                      widget.valueBuilder?.call(_controller) ??
                      _controller.text.trim();
                  Navigator.of(context).pop(value);
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Сохранить'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Отмена'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
