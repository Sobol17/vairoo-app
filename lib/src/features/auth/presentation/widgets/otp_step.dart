import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/shared/helpers/formatter.dart';
import 'package:ai_note/src/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OtpStep extends StatefulWidget {
  const OtpStep({
    super.key,
    required this.phoneNumber,
    required this.isLoading,
    required this.errorText,
    required this.onSubmit,
    required this.onResend,
  });

  final String phoneNumber;
  final bool isLoading;
  final String? errorText;
  final ValueChanged<String> onSubmit;
  final VoidCallback? onResend;

  @override
  State<OtpStep> createState() => _OtpStepState();
}

class _OtpStepState extends State<OtpStep> {
  final formatter = Formatter();
  static const _codeLength = 4;

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_codeLength, (_) => TextEditingController());
    _focusNodes = List.generate(_codeLength, (_) => FocusNode());
    for (final node in _focusNodes) {
      node.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNodes.first.requestFocus();
      }
    });
  }

  @override
  void didUpdateWidget(covariant OtpStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.phoneNumber != widget.phoneNumber) {
      for (final controller in _controllers) {
        controller.clear();
      }
      if (!widget.isLoading && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _focusNodes.first.requestFocus();
          }
        });
      }
    }
    if (oldWidget.isLoading && !widget.isLoading && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final emptyIndex = _controllers.indexWhere((c) => c.text.isEmpty);
          final index = emptyIndex == -1 ? _codeLength - 1 : emptyIndex;
          _focusNodes[index].requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleChanged(String value, int index) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 1) {
      _spreadDigitsFrom(index, digits);
      return;
    }
    _setDigit(index, digits);
    if (digits.isNotEmpty) {
      if (index < _codeLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _submitIfComplete();
      }
    } else if (index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _spreadDigitsFrom(int index, String digits) {
    var targetIndex = index;
    for (var i = 0; i < digits.length; i++) {
      final digit = digits[i];
      if (targetIndex >= _codeLength) {
        break;
      }
      _setDigit(targetIndex, digit);
      targetIndex++;
    }
    final nextIndex = (targetIndex - 1).clamp(0, _codeLength - 1);
    if (nextIndex < _codeLength - 1) {
      _focusNodes[nextIndex + 1].requestFocus();
    } else {
      _submitIfComplete();
    }
  }

  void _setDigit(int index, String value) {
    final controller = _controllers[index];
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  String _collectCode() {
    final buffer = StringBuffer();
    for (final controller in _controllers) {
      buffer.write(controller.text);
    }
    return buffer.toString();
  }

  void _submitIfComplete() {
    final code = _collectCode();
    if (code.length == _codeLength && !widget.isLoading) {
      widget.onSubmit(code);
    }
  }

  void _handleSubmit() {
    final code = _collectCode();
    widget.onSubmit(code);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final formattedPhone = formatter.formatPhoneNumber(widget.phoneNumber);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Введите код из SMS',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Выслан код на номер $formattedPhone',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_codeLength, (index) {
            final focusNode = _focusNodes[index];
            final controller = _controllers[index];
            final hasValue = controller.text.isNotEmpty;
            final isFocused = focusNode.hasFocus;
            final shadowOpacity = (isFocused || hasValue) ? 0.12 : 0.04;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: shadowOpacity),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  enabled: !widget.isLoading,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: primary,
                  ),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(counterText: ''),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) => _handleChanged(value, index),
                  onTap: () => controller.selection = TextSelection.collapsed(
                    offset: controller.text.length,
                  ),
                ),
              ),
            );
          }),
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
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.center,
          child: TextButton.icon(
            onPressed: widget.isLoading ? null : widget.onResend,
            icon: const Icon(Icons.mail_outline_rounded),
            label: const Text('Выслать повторно'),
            style: TextButton.styleFrom(
              foregroundColor: primary,
              textStyle: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SvgPicture.asset('assets/icons/otp_bg.svg', fit: BoxFit.contain),
        const Spacer(),
        PrimaryButton(
          label: 'Продолжить',
          onPressed: widget.isLoading ? null : _handleSubmit,
          isLoading: widget.isLoading,
        ),
      ],
    );
  }
}
