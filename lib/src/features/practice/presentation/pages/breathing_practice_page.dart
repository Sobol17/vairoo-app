import 'dart:async';

import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BreathingPracticePage extends StatefulWidget {
  const BreathingPracticePage({super.key});

  @override
  State<BreathingPracticePage> createState() => _BreathingPracticePageState();
}

enum _PracticeState { idle, running, paused }

class _BreathingPracticePageState extends State<BreathingPracticePage>
    with TickerProviderStateMixin {
  static const double _minCircleScale = 0.85;
  static const double _maxCircleScale = 1.35;

  static final List<_BreathingPhase> _phases = [
    _BreathingPhase(
      label: 'Вдох',
      description: 'Наполняйте легкие воздухом через нос',
      icon: Icons.air,
      duration: const Duration(seconds: 4),
      targetScale: _maxCircleScale,
    ),
    _BreathingPhase(
      label: 'Задержите дыхание',
      description: 'Мягко удерживайте воздух внутри',
      icon: Icons.pause_rounded,
      duration: const Duration(seconds: 3),
      targetScale: _maxCircleScale,
    ),
    _BreathingPhase(
      label: 'Выдох',
      description: 'Медленно отпускайте напряжение через рот',
      icon: Icons.waves,
      duration: const Duration(seconds: 4),
      targetScale: _minCircleScale,
    ),
    _BreathingPhase(
      label: 'Пауза',
      description: 'Короткий отдых перед новым вдохом',
      icon: Icons.pause_circle_filled,
      duration: const Duration(seconds: 2),
      targetScale: _minCircleScale,
    ),
  ];

  Timer? _timer;
  Duration _elapsed = Duration.zero;
  int _phaseIndex = 0;
  _PracticeState _state = _PracticeState.idle;
  late AnimationController _scaleController;
  late Tween<double> _scaleTween;
  double _currentScale = _minCircleScale;

  @override
  void initState() {
    super.initState();
    _scaleTween = Tween<double>(begin: _currentScale, end: _currentScale);
    _scaleController =
        AnimationController(vsync: this, duration: _phases.first.duration)
          ..addListener(() {
            if (!mounted) {
              return;
            }
            final value = _evaluateScaleTween();
            if (value != _currentScale) {
              setState(() {
                _currentScale = value;
              });
            }
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed &&
                _state == _PracticeState.running) {
              _advancePhase();
            }
          });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scaleController.dispose();
    super.dispose();
  }

  void _onCircleTap() {
    switch (_state) {
      case _PracticeState.idle:
        _startSession();
        break;
      case _PracticeState.running:
        _pauseSession();
        break;
      case _PracticeState.paused:
        _resumeSession();
        break;
    }
  }

  void _startSession() {
    _timer?.cancel();
    setState(() {
      _state = _PracticeState.running;
      _elapsed = Duration.zero;
      _phaseIndex = 0;
      _currentScale = _minCircleScale;
      _scaleTween = Tween(begin: _currentScale, end: _currentScale);
      _scaleController.value = 0;
    });
    _startElapsedTicker();
    _animateCircleForPhase(_phases.first);
  }

  void _pauseSession() {
    _timer?.cancel();
    _scaleController.stop();
    setState(() {
      _state = _PracticeState.paused;
    });
  }

  void _resumeSession() {
    if (_state != _PracticeState.paused) {
      return;
    }
    setState(() {
      _state = _PracticeState.running;
    });
    _startElapsedTicker();
    _scaleController.forward();
  }

  void _resetSession() {
    _timer?.cancel();
    _scaleController.stop();
    setState(() {
      _state = _PracticeState.idle;
      _elapsed = Duration.zero;
      _phaseIndex = 0;
      _currentScale = _minCircleScale;
      _scaleTween = Tween(begin: _currentScale, end: _currentScale);
      _scaleController.value = 0;
    });
  }

  void _startElapsedTicker() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        return;
      }
      setState(() {
        _elapsed += const Duration(seconds: 1);
      });
    });
  }

  void _advancePhase() {
    setState(() {
      _phaseIndex = (_phaseIndex + 1) % _phases.length;
    });
    _animateCircleForPhase(_phases[_phaseIndex]);
  }

  void _animateCircleForPhase(_BreathingPhase phase) {
    _scaleController.duration = phase.duration;
    _scaleTween = Tween(begin: _currentScale, end: phase.targetScale);
    _scaleController.forward(from: 0);
  }

  double _evaluateScaleTween() {
    final begin = _scaleTween.begin ?? _currentScale;
    final end = _scaleTween.end ?? _currentScale;
    final progress = Curves.easeInOut.transform(_scaleController.value);
    return begin + (end - begin) * progress;
  }

  String get _timerLabel {
    final minutes = _elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = _elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get _phaseTitle {
    if (_state == _PracticeState.idle) {
      return 'Нажмите «Старт», закройте глаза и настройтесь на дыхание';
    }
    return _phases[_phaseIndex].label.toUpperCase();
  }

  String get _phaseDescription {
    if (_state == _PracticeState.idle) {
      return 'Удобно расположитесь и сосредоточьтесь на себе';
    }
    return _phases[_phaseIndex].description;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/relax.png', fit: BoxFit.cover),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x99000000), Color(0xCC000000)],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black26,
                      ),
                      icon: const Icon(Icons.chevron_left_rounded),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _timerLabel,
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.4,
                          ),
                        ),
                        const SizedBox(height: 36),
                        GestureDetector(
                          onTap: _onCircleTap,
                          child: Transform.scale(
                            scale: _currentScale,
                            child: _BreathingCircleContent(
                              state: _state,
                              phase: _phases[_phaseIndex],
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          _phaseTitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          child: Text(
                            _phaseDescription,
                            key: ValueKey(_phaseDescription),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white70,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_state != _PracticeState.idle)
                    TextButton(
                      onPressed: _resetSession,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white70,
                        textStyle: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Завершить практику'),
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

class _BreathingCircleContent extends StatelessWidget {
  const _BreathingCircleContent({required this.state, required this.phase});

  final _PracticeState state;
  final _BreathingPhase phase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.secondary.withValues(alpha: 0.9),
            AppColors.secondary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.55),
            blurRadius: 70,
            spreadRadius: 6,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.35),
        ),
        child: Center(child: _buildInnerContent(theme)),
      ),
    );
  }

  Widget _buildInnerContent(ThemeData theme) {
    switch (state) {
      case _PracticeState.idle:
        return Text(
          'СТАРТ',
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        );
      case _PracticeState.paused:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 42),
            const SizedBox(height: 6),
            Text(
              'ПРОДОЛЖИТЬ',
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
          ],
        );
      case _PracticeState.running:
        return Icon(phase.icon, color: Colors.white, size: 40);
    }
  }
}

class _BreathingPhase {
  const _BreathingPhase({
    required this.label,
    required this.description,
    required this.icon,
    required this.duration,
    required this.targetScale,
  });

  final String label;
  final String description;
  final IconData icon;
  final Duration duration;
  final double targetScale;
}
