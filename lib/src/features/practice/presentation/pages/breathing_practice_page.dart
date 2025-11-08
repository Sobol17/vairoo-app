import 'dart:async';

import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BreathingPracticePage extends StatefulWidget {
  const BreathingPracticePage({super.key});

  @override
  State<BreathingPracticePage> createState() => _BreathingPracticePageState();
}

class _BreathingPracticePageState extends State<BreathingPracticePage> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _isRunning = false;
  bool _isInhalePhase = true;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isRunning) {
      _resetTimer();
    } else {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _elapsed = Duration.zero;
      _isInhalePhase = true;
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsed += const Duration(seconds: 1);
        if (_elapsed.inSeconds > 0 && _elapsed.inSeconds % 5 == 0) {
          _isInhalePhase = !_isInhalePhase;
        }
      });
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _elapsed = Duration.zero;
      _isRunning = false;
      _isInhalePhase = true;
    });
  }

  String get _timerLabel {
    final minutes = _elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = _elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get _primaryInstruction =>
      _isInhalePhase ? 'Глубокий вдох' : 'Плавный выдох';

  String get _secondaryInstruction => _isInhalePhase ? 'Выдох' : 'Вдох';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/relax.png', fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.35)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.chevron_left_rounded),
                      label: const Text('Назад'),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    _timerLabel,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: Column(
                      key: ValueKey(_primaryInstruction),
                      children: [
                        Text(
                          _primaryInstruction,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _secondaryInstruction,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: _toggleTimer,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.secondary.withValues(
                        alpha: 0.92,
                      ),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    icon: Icon(
                      _isRunning
                          ? Icons.stop_rounded
                          : Icons.play_arrow_rounded,
                    ),
                    label: Text(_isRunning ? 'Завершить' : 'Начать'),
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
