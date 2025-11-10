import 'package:ai_note/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:ai_note/src/features/auth/presentation/widgets/auth_header.dart';
import 'package:ai_note/src/features/auth/presentation/widgets/goal_step.dart';
import 'package:ai_note/src/features/auth/presentation/widgets/habit_spending_step.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/birthdate_step.dart';
import '../widgets/otp_step.dart';
import '../widgets/payment_step.dart';
import '../widgets/phone_step.dart';
import '../widgets/welcome_step.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Consumer<AuthController>(
          builder: (context, controller, _) {
            if (controller.step == AuthStep.authenticated) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _AuthBody(controller: controller),
            );
          },
        ),
      ),
    );
  }
}

class _AuthBody extends StatelessWidget {
  const _AuthBody({required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    final step = controller.step;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthHeader(
          isLoading: controller.isLoading,
          onBack: switch (step) {
            AuthStep.otpInput => () => controller.showPhoneInput(
              clearPhone: false,
            ),
            AuthStep.birthdateInput => controller.backToOtp,
            AuthStep.paymentInput => controller.backToGoal,
            AuthStep.habitSpendingInput => controller.backToPayment,
            AuthStep.goalInput => controller.backToBirthdate,
            (_) => null,
          },
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 0),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: switch (step) {
                    AuthStep.welcome => WelcomeStep(
                      key: const ValueKey('welcome_step'),
                      onStart: controller.isLoading
                          ? null
                          : () => controller.showPhoneInput(),
                      onPrivacyTap: () => _showComingSoon(context),
                      onPersonalPolicyTap: () => _showComingSoon(context),
                    ),
                    AuthStep.phoneInput => PhoneStep(
                      key: const ValueKey('phone_step'),
                      initialPhone: controller.phoneNumber,
                      isLoading: controller.isLoading,
                      errorText: controller.errorMessage,
                      onSubmit: controller.submitPhone,
                    ),
                    AuthStep.otpInput => OtpStep(
                      key: const ValueKey('otp_step'),
                      phoneNumber: controller.phoneNumber,
                      isLoading: controller.isLoading,
                      errorText: controller.errorMessage,
                      onSubmit: controller.submitCode,
                      onResend: controller.phoneNumber.isEmpty
                          ? null
                          : () =>
                                controller.submitPhone(controller.phoneNumber),
                    ),
                    AuthStep.birthdateInput => BirthdateStep(
                      key: const ValueKey('birthdate_step'),
                      initialDate: controller.birthDate,
                      isLoading: controller.isLoading,
                      onSubmit: (date) => controller.completeBirthdate(date),
                      onSkip: () => controller.completeBirthdate(null),
                    ),
                    AuthStep.goalInput => GoalStep(
                      isLoading: controller.isLoading,
                      initialGoal: controller.goal,
                      onSubmit: (goal) => controller.completeGoal(goal),
                    ),
                    AuthStep.paymentInput => PaymentStep(
                      key: const ValueKey('payment_step'),
                      isLoading: controller.isLoading,
                      onStartTrial: controller.completePayment,
                    ),
                    AuthStep.habitSpendingInput => HabitSpendingStep(
                      key: const ValueKey('habit_spending_step'),
                      isLoading: controller.isLoading,
                      initialValue: controller.habitSpending,
                      onSubmit: controller.completeHabitSpending,
                      onSkip: controller.skipHabitSpending,
                    ),
                    AuthStep.authenticated => const SizedBox.shrink(),
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static void _showComingSoon(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Раздел с документами скоро появится в приложении.'),
      ),
    );
  }
}
