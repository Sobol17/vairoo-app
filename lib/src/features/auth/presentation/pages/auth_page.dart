import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ai_note/src/features/auth/presentation/controllers/auth_controller.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Consumer<AuthController>(
              builder: (context, controller, _) {
                switch (controller.step) {
                  case AuthStep.phoneInput:
                    return _PhoneStep(
                      isLoading: controller.isLoading,
                      errorText: controller.errorMessage,
                      onSubmit: controller.submitPhone,
                    );
                  case AuthStep.otpInput:
                    return _OtpStep(
                      phoneNumber: controller.phoneNumber,
                      isLoading: controller.isLoading,
                      errorText: controller.errorMessage,
                      onSubmit: controller.submitCode,
                      onBack: controller.reset,
                    );
                  case AuthStep.authenticated:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _PhoneStep extends StatefulWidget {
  const _PhoneStep({
    required this.isLoading,
    required this.errorText,
    required this.onSubmit,
  });

  final bool isLoading;
  final String? errorText;
  final ValueChanged<String> onSubmit;

  @override
  State<_PhoneStep> createState() => _PhoneStepState();
}

class _PhoneStepState extends State<_PhoneStep> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    widget.onSubmit(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Введите номер телефона, чтобы получить код подтверждения.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Номер телефона',
            hintText: '+7 999 000-00-00',
          ),
          enabled: !widget.isLoading,
          onSubmitted: (_) => _handleSubmit(),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 16),
          Text(
            widget.errorText!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: widget.isLoading ? null : _handleSubmit,
          child: widget.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Продолжить'),
        ),
      ],
    );
  }
}

class _OtpStep extends StatefulWidget {
  const _OtpStep({
    required this.phoneNumber,
    required this.isLoading,
    required this.errorText,
    required this.onSubmit,
    required this.onBack,
  });

  final String phoneNumber;
  final bool isLoading;
  final String? errorText;
  final ValueChanged<String> onSubmit;
  final VoidCallback onBack;

  @override
  State<_OtpStep> createState() => _OtpStepState();
}

class _OtpStepState extends State<_OtpStep> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant _OtpStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.phoneNumber != widget.phoneNumber) {
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    widget.onSubmit(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Введите код из SMS, отправленного на номер ${widget.phoneNumber}.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: const InputDecoration(
            labelText: 'Код из SMS',
            counterText: '',
          ),
          enabled: !widget.isLoading,
          onSubmitted: (_) => _handleSubmit(),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 16),
          Text(
            widget.errorText!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: widget.isLoading ? null : _handleSubmit,
          child: widget.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Подтвердить'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: widget.isLoading ? null : widget.onBack,
          child: const Text('Изменить номер телефона'),
        ),
      ],
    );
  }
}
