import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/auth/presentation/widgets/brand_logo.dart';
import 'package:ai_note/src/features/profile/domain/entities/profile.dart';
import 'package:ai_note/src/features/profile/presentation/controllers/profile_controller.dart';
import 'package:ai_note/src/shared/helpers/formatter.dart';
import 'package:ai_note/src/shared/helpers/phone_mask.dart';
import 'package:ai_note/src/shared/widgets/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

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
  bool _isSaving = false;
  ProfileController? _profileController;
  Profile? _lastProfile;

  @override
  void initState() {
    super.initState();
    _formatter = Formatter();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _initializePhoneController('');
    _birthDate = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = context.read<ProfileController>();
    if (!identical(_profileController, controller)) {
      _profileController?.removeListener(_onProfileUpdated);
      _profileController = controller;
      _profileController?.addListener(_onProfileUpdated);
      _onProfileUpdated();
    }
  }

  @override
  void dispose() {
    _profileController?.removeListener(_onProfileUpdated);
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _initializePhoneController(String phone) {
    final digits = _prepareDigitsForMask(phone);
    final mask = _createPhoneMask(
      initialDigits: digits.isEmpty ? null : digits,
    );
    final masked = mask.getMaskedText();
    _phoneDigits = masked.isEmpty ? null : mask.getUnmaskedText();
    _phoneController.text = masked;
  }

  void _onProfileUpdated() {
    final controller = _profileController;
    if (controller == null) {
      return;
    }
    final profile = controller.profile;
    if (_lastProfile == profile) {
      return;
    }
    setState(() {
    _lastProfile = profile;
    _nameController.text = profile.name;
    _emailController.text = profile.email ?? '';
    _birthDate = profile.birthDate;
    _initializePhoneController(profile.phone ?? '');
    });
  }

  Future<void> _selectBirthDate() async {
    FocusScope.of(context).unfocus();
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CalendarPickerBottomSheet(
        initialDate: _birthDate,
        minDate: DateTime(1940),
        maxDate: DateTime.now(),
      ),
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

  Future<void> _handleContinue() async {
    if (_isSaving) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);
    final emailText = _emailController.text.trim();
    try {
      final controller = _profileController;
      if (controller == null) {
        throw StateError('ProfileController is not available');
      }
      await controller.submitProfileInfo(
        name: _nameController.text,
        birthDate: _birthDate,
        email: emailText.isEmpty ? null : emailText,
      );
      if (mounted) {
        context.pop(true);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не удалось сохранить изменения: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
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
                                onPressed: () => context.pop(),
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
                        onPressed: _isSaving ? null : _handleContinue,
                        child: _isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Продолжить'),
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

class _CalendarPickerBottomSheet extends StatefulWidget {
  const _CalendarPickerBottomSheet({
    required this.initialDate,
    required this.minDate,
    required this.maxDate,
  });

  final DateTime? initialDate;
  final DateTime minDate;
  final DateTime maxDate;

  @override
  State<_CalendarPickerBottomSheet> createState() =>
      _CalendarPickerBottomSheetState();
}

class _CalendarPickerBottomSheetState
    extends State<_CalendarPickerBottomSheet> {
  late DateTime _visibleMonth;
  DateTime? _selectedDate;
  final Formatter _formatter = Formatter();

  DateTime get _minMonth => DateTime(widget.minDate.year, widget.minDate.month);
  DateTime get _maxMonth => DateTime(widget.maxDate.year, widget.maxDate.month);

  @override
  void initState() {
    super.initState();
    final initial = widget.initialDate != null
        ? _normalizeDate(widget.initialDate!)
        : null;
    _selectedDate = initial;
    _visibleMonth = DateTime(
      (initial ?? widget.maxDate).year,
      (initial ?? widget.maxDate).month,
    );
    _clampVisibleMonth();
  }

  void _clampVisibleMonth() {
    if (_visibleMonth.isBefore(_minMonth)) {
      _visibleMonth = _minMonth;
    }
    if (_visibleMonth.isAfter(_maxMonth)) {
      _visibleMonth = _maxMonth;
    }
  }

  DateTime _normalizeDate(DateTime value) {
    var result = DateTime(value.year, value.month, value.day);
    if (result.isBefore(widget.minDate)) {
      result = DateTime(
        widget.minDate.year,
        widget.minDate.month,
        widget.minDate.day,
      );
    }
    if (result.isAfter(widget.maxDate)) {
      result = DateTime(
        widget.maxDate.year,
        widget.maxDate.month,
        widget.maxDate.day,
      );
    }
    return result;
  }

  bool get _canGoPrev {
    final prev = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    return !prev.isBefore(_minMonth);
  }

  bool get _canGoNext {
    final next = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    return !next.isAfter(_maxMonth);
  }

  void _changeMonth(int delta) {
    final candidate = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    if (candidate.isBefore(_minMonth) || candidate.isAfter(_maxMonth)) {
      return;
    }
    setState(() {
      _visibleMonth = candidate;
    });
  }

  void _changeYear(int year) {
    setState(() {
      _visibleMonth = DateTime(year, _visibleMonth.month);
      _clampVisibleMonth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Container(
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 36,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.chevron_left_rounded),
                          label: const Text('Назад'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.secondary,
                            textStyle: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Календарь',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                CalendarHeader(
                  monthLabel: _formatter.formatMonth(_visibleMonth),
                  primary: AppColors.primary,
                  onPrev: _canGoPrev ? () => _changeMonth(-1) : null,
                  onNext: _canGoNext ? () => _changeMonth(1) : null,
                  year: _visibleMonth.year,
                  minYear: widget.minDate.year,
                  maxYear: widget.maxDate.year,
                  onYearChanged: _changeYear,
                ),
                const SizedBox(height: 12),
                CalendarGrid(
                  visibleMonth: _visibleMonth,
                  selectedDate: _selectedDate,
                  minDate: widget.minDate,
                  maxDate: widget.maxDate,
                  selectionMode: CalendarSelectionMode.single,
                  onSelect: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _selectedDate == null
                        ? null
                        : () => Navigator.of(context).pop(_selectedDate),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: const Text('Выбрать'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
