import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/shared/helpers/formatter.dart';
import 'package:Vairoo/src/shared/widgets/calendar.dart';
import 'package:Vairoo/src/shared/widgets/primary_button.dart';
import 'package:Vairoo/src/shared/widgets/secondary_button.dart';
import 'package:flutter/material.dart';

class BirthdateStep extends StatefulWidget {
  const BirthdateStep({
    super.key,
    required this.initialDate,
    required this.isLoading,
    required this.onSubmit,
    required this.onSkip,
  });

  final DateTime? initialDate;
  final bool isLoading;
  final ValueChanged<DateTime> onSubmit;
  final VoidCallback onSkip;

  @override
  State<BirthdateStep> createState() => _BirthdateStepState();
}

class _BirthdateStepState extends State<BirthdateStep> {
  final formatter = Formatter();

  static final DateTime _minDate = DateTime(1900, 1);
  static final DateTime _maxDate = DateTime.now();
  static final DateTime _latestAllowedBirthdate = DateTime(2010, 12, 31);

  late DateTime _visibleMonth;
  DateTime? _selectedDate;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialDate?.isBefore(_minDate) == true
        ? _minDate
        : widget.initialDate;
    _selectedDate = initial;
    _visibleMonth = DateTime(
      (initial ?? _maxDate).year,
      (initial ?? _maxDate).month,
    );
    _clampVisibleMonth();
  }

  @override
  void didUpdateWidget(covariant BirthdateStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDate != widget.initialDate) {
      final initial = widget.initialDate;
      if (initial == null) {
        _selectedDate = null;
        _visibleMonth = DateTime(_maxDate.year, _maxDate.month);
      } else {
        _selectedDate = initial;
        _visibleMonth = DateTime(initial.year, initial.month);
      }
      _clampVisibleMonth();
    }
  }

  void _clampVisibleMonth() {
    final minMonth = DateTime(_minDate.year, _minDate.month);
    final maxMonth = DateTime(_maxDate.year, _maxDate.month);
    if (_visibleMonth.isBefore(minMonth)) {
      _visibleMonth = minMonth;
    }
    if (_visibleMonth.isAfter(maxMonth)) {
      _visibleMonth = maxMonth;
    }
  }

  void _changeMonth(int delta) {
    final candidate = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    final minMonth = DateTime(_minDate.year, _minDate.month);
    final maxMonth = DateTime(_maxDate.year, _maxDate.month);
    if (candidate.isBefore(minMonth) || candidate.isAfter(maxMonth)) {
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

  bool get _canGoPrev {
    final minMonth = DateTime(_minDate.year, _minDate.month);
    final prev = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    return !prev.isBefore(minMonth);
  }

  bool get _canGoNext {
    final maxMonth = DateTime(_maxDate.year, _maxDate.month);
    final next = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    return !next.isAfter(maxMonth);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Выберите вашу дату рождения',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgGray,
            borderRadius: BorderRadius.circular(3),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Дата рождения',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              Text(
                _selectedDate != null
                    ? formatter.formatFullDate(_selectedDate!)
                    : 'Не выбрана',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CalendarHeader(
          monthLabel: formatter.formatMonth(_visibleMonth),
          primary: primary,
          onPrev: _canGoPrev ? () => _changeMonth(-1) : null,
          onNext: _canGoNext ? () => _changeMonth(1) : null,
          year: _visibleMonth.year,
          minYear: _minDate.year,
          maxYear: _maxDate.year,
          onYearChanged: widget.isLoading ? null : _changeYear,
        ),
        const SizedBox(height: 12),
        CalendarGrid(
          visibleMonth: _visibleMonth,
          selectedDate: _selectedDate,
          minDate: _minDate,
          maxDate: _maxDate,
          onSelect: widget.isLoading
              ? null
              : (date) {
                  setState(() {
                    _selectedDate = date;
                    _errorText = _isTooYoung(date)
                        ? 'Приложение доступно пользователям, родившимся не позже 2010 года'
                        : null;
                  });
                },
        ),
        if (_errorText != null) ...[
          const SizedBox(height: 12),
          Text(
            _errorText!,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const Spacer(),
        PrimaryButton(
          label: 'Продолжить',
          onPressed: _selectedDate != null && !_isTooYoung(_selectedDate!)
              ? _handleContinue
              : null,
          isLoading: widget.isLoading,
        ),
        const SizedBox(height: 8),
        SecondaryButton(
          label: 'Выбрать позже',
          onPressed: widget.isLoading ? null : widget.onSkip,
        ),
      ],
    );
  }

  void _handleContinue() {
    final selected = _selectedDate;
    if (selected == null) {
      setState(() {
        _errorText = 'Пожалуйста, выберите дату рождения';
      });
      return;
    }
    if (_isTooYoung(selected)) {
      setState(() {
        _errorText =
            'Приложение доступно пользователям, родившимся не позже 2010 года';
      });
      return;
    }
    widget.onSubmit(selected);
  }

  bool _isTooYoung(DateTime date) => date.isAfter(_latestAllowedBirthdate);
}
