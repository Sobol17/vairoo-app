import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/profile/domain/entities/profile.dart';
import 'package:Vairoo/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AchievementPage extends StatefulWidget {
  const AchievementPage({super.key, required this.type});

  final ProfileAchievementType type;

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  bool _isAcknowledging = false;
  String? _error;

  Future<void> _handleAcknowledge(BuildContext context) async {
    if (_isAcknowledging) {
      return;
    }
    setState(() {
      _isAcknowledging = true;
      _error = null;
    });
    try {
      await context.read<ProfileRepository>().acknowledgeAchievement(
        widget.type,
      );
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop();
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      setState(() {
        final message = error.toString();
        _error = message.startsWith('Exception: ')
            ? message.substring('Exception: '.length)
            : message;
        _isAcknowledging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _AchievementConfig.fromType(widget.type);
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: config.backgroundGradient,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned.fill(
            child: _AchievementBackground(assetPath: config.assetPath),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  _AchievementHeader(textColor: config.textColor),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (config.subtitle != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                config.subtitle!,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: config.textColor.withValues(
                                    alpha: 0.85,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 20),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: config.textColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                                children: [
                                  for (final span in config.descriptionSpans)
                                    TextSpan(
                                      text: span.text,
                                      style: span.highlight
                                          ? TextStyle(
                                              color: config.accentColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                            )
                                          : null,
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: config.buttonColor,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                onPressed: _isAcknowledging
                                    ? null
                                    : () => _handleAcknowledge(context),
                                child: _isAcknowledging
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : Text(
                                        config.buttonLabel,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                              ),
                            ),
                            if (_error != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                _error!,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementHeader extends StatelessWidget {
  const _AchievementHeader({required this.textColor});

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: AppColors.primary,
              ),
              label: const Text('Назад'),
            ),
          ),
          SvgPicture.asset('assets/icons/logo.svg', height: 32),
        ],
      ),
    );
  }
}

class _AchievementBackground extends StatelessWidget {
  const _AchievementBackground({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(child: SvgPicture.asset(assetPath, fit: BoxFit.cover));
  }
}

class _AchievementConfig {
  const _AchievementConfig({
    required this.title,
    required this.descriptionSpans,
    required this.buttonLabel,
    required this.assetPath,
    required this.backgroundGradient,
    required this.buttonColor,
    required this.accentColor,
    this.subtitle,
    this.textColor = AppColors.primary,
  });

  final String title;
  final String? subtitle;
  final List<_AchievementTextSpan> descriptionSpans;
  final String buttonLabel;
  final String assetPath;
  final List<Color> backgroundGradient;
  final Color textColor;
  final Color buttonColor;
  final Color accentColor;

  static _AchievementConfig fromType(ProfileAchievementType type) {
    switch (type) {
      case ProfileAchievementType.planCompleted:
        return _AchievementConfig(
          title: 'ПЛАН ЗАВЕРШЕН',
          subtitle: 'Поздравляем, Вы проделали отличную работу!',
          descriptionSpans: const [
            _AchievementTextSpan('Продолжайте путь вместе с Vairoo.'),
          ],
          buttonLabel: 'Продолжить путь!',
          assetPath: 'assets/icons/goal_bg.svg',
          backgroundGradient: const [Color(0xFFFFF2E7), Color(0xFFE3F1F0)],
          buttonColor: AppColors.primary,
          accentColor: const Color(0xFFF47B4A),
          textColor: AppColors.primary,
        );
      case ProfileAchievementType.twentyDays:
        return _AchievementConfig(
          title: 'СВОБОДНЫЙ ЧЕЛОВЕК',
          subtitle: 'Вы сможете что угодно, если приложите достаточно усилий',
          descriptionSpans: const [
            _AchievementTextSpan('Поздравляем, достижение за '),
            _AchievementTextSpan('20 дней', highlight: true),
            _AchievementTextSpan(' трезвости получено!'),
          ],
          buttonLabel: 'Спасибо',
          assetPath: 'assets/icons/push_illustration.svg',
          backgroundGradient: const [Color(0xFFF8FCFF), Color(0xFFD6F1EF)],
          buttonColor: const Color(0xFF5CC6C1),
          accentColor: const Color(0xFFF47B4A),
          textColor: AppColors.primary,
        );
      case ProfileAchievementType.sevenDays:
        return _AchievementConfig(
          title: 'НАМЕЧЕННЫЙ ПУТЬ',
          subtitle: 'Продолжайте в том же духе — всё получится',
          descriptionSpans: const [
            _AchievementTextSpan('Вы сохраняете трезвость уже '),
            _AchievementTextSpan('7 дней', highlight: true),
            _AchievementTextSpan('! Мы гордимся вами.'),
          ],
          buttonLabel: 'Спасибо',
          assetPath: 'assets/icons/habit_illustration.svg',
          backgroundGradient: const [Color(0xFFFFF5E7), Color(0xFFE4F0EF)],
          buttonColor: const Color(0xFFF47B4A),
          accentColor: const Color(0xFFF47B4A),
          textColor: AppColors.primary,
        );
      case ProfileAchievementType.firstDay:
        return _AchievementConfig(
          title: 'ПЕРВЫЙ ДЕНЬ',
          descriptionSpans: const [
            _AchievementTextSpan('Поздравляем, достижение за '),
            _AchievementTextSpan('первый день', highlight: true),
            _AchievementTextSpan(' трезвости получено!'),
          ],
          buttonLabel: 'Спасибо',
          assetPath: 'assets/icons/achievements/first.svg',
          backgroundGradient: const [Color(0xFFFFFFFF), Color(0xFFE2F1EF)],
          buttonColor: AppColors.secondary,
          accentColor: const Color(0xFFF47B4A),
          textColor: AppColors.surface,
        );
    }
  }
}

class _AchievementTextSpan {
  const _AchievementTextSpan(this.text, {this.highlight = false});

  final String text;
  final bool highlight;
}
