import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/shared/helpers/formatter.dart';
import 'package:ai_note/src/shared/helpers/phone_mask.dart';
import 'package:ai_note/src/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PhoneStep extends StatefulWidget {
  const PhoneStep({
    super.key,
    required this.initialPhone,
    required this.isLoading,
    required this.errorText,
    required this.onSubmit,
  });

  final String initialPhone;
  final bool isLoading;
  final String? errorText;
  final ValueChanged<String> onSubmit;

  @override
  State<PhoneStep> createState() => _PhoneStepState();
}

class _PhoneStepState extends State<PhoneStep> {
  final formatter = Formatter();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_handleTextChanged);
    _syncWithInitialPhone();
  }

  @override
  void didUpdateWidget(covariant PhoneStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialPhone != widget.initialPhone) {
      _syncWithInitialPhone();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    final digits = _extractDigits(_controller.text);
    final formatted = formatter.applyPhoneMask(digits);
    if (_controller.text != formatted) {
      _controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void _syncWithInitialPhone() {
    final digits = _extractDigits(widget.initialPhone);
    final formatted = formatter.applyPhoneMask(digits);
    _controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _composePhone() {
    var digits = _extractDigits(_controller.text);
    if (digits.isEmpty) {
      return '';
    }
    if (digits.length > 11) {
      digits = digits.substring(0, 11);
    }
    if (digits.length < 10) {
      return digits;
    }
    if (digits.length == 10) {
      return '+7$digits';
    }
    if (digits.startsWith('8') || digits.startsWith('7')) {
      return '+7${digits.substring(1)}';
    }
    return '+$digits';
  }

  void _handleSubmit() {
    final value = _composePhone();
    widget.onSubmit(value);
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
          'Войдите или зарегистрируйтесь',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Введите номер телефона для получения кода из SMS',
          textAlign: TextAlign.center,
          style: secondaryText,
        ),
        const SizedBox(height: 28),
        TextField(
          controller: _controller,
          enabled: !widget.isLoading,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(hintText: 'Номер телефона'),
          onSubmitted: (_) => _handleSubmit(),
          inputFormatters: [phoneMask],
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 12),
          Text(
            widget.errorText!,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const SizedBox(height: 32),
        Transform.scale(
          scale: 1.15,
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/sms_bg.svg',
            fit: BoxFit.fitWidth,
          ),
        ),
        const Spacer(),
        PrimaryButton(
          label: 'Войти',
          onPressed: widget.isLoading ? null : _handleSubmit,
          isLoading: widget.isLoading,
        ),
      ],
    );
  }

  String _extractDigits(String input) =>
      input.replaceAll(RegExp(r'[^0-9]'), '');
}
