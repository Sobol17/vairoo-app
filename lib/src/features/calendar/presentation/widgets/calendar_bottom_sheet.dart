import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/shared/helpers/formatter.dart';
import 'package:ai_note/src/shared/widgets/calendar.dart';
import 'package:flutter/material.dart';

class PlanCalendarBottomSheet extends StatefulWidget {
  const PlanCalendarBottomSheet({this.initialDate});

  final DateTime? initialDate;

  @override
  State<PlanCalendarBottomSheet> createState() =>
      _PlanCalendarBottomSheetState();
}

class _PlanCalendarBottomSheetState extends State<PlanCalendarBottomSheet> {
  late DateTime _visibleMonth;
  late DateTime _minDate;
  late DateTime _maxDate;
  DateTime? _selectedDate;
  final Formatter _formatter = Formatter();

  DateTime get _minMonth => DateTime(_minDate.year, _minDate.month);
  DateTime get _maxMonth => DateTime(_maxDate.year, _maxDate.month);

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final initial = widget.initialDate ?? DateTime(now.year, now.month, now.day);
    _visibleMonth = DateTime(initial.year, initial.month);
    _selectedDate = initial;
    _minDate = DateTime(now.year - 1, 1, 1);
    _maxDate = DateTime(now.year + 1, 12, 31);
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
    final candidate = DateTime(year, _visibleMonth.month);
    if (candidate.isBefore(_minMonth) || candidate.isAfter(_maxMonth)) {
      return;
    }
    setState(() {
      _visibleMonth = candidate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final selectedLabel = _selectedDate == null
        ? 'Выберите день практики'
        : 'Выбрано: ${_formatter.formatFullDate(_selectedDate!)}';

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
                  height: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                          splashRadius: 22,
                        ),
                      ),
                      Text(
                        'Календарь практики',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                CalendarHeader(
                  monthLabel: _formatter.formatMonth(_visibleMonth),
                  primary: AppColors.primary,
                  onPrev: _canGoPrev ? () => _changeMonth(-1) : null,
                  onNext: _canGoNext ? () => _changeMonth(1) : null,
                  year: _visibleMonth.year,
                  minYear: _minDate.year,
                  maxYear: _maxDate.year,
                  onYearChanged: _changeYear,
                ),
                const SizedBox(height: 12),
                CalendarGrid(
                  visibleMonth: _visibleMonth,
                  selectedDate: _selectedDate,
                  minDate: _minDate,
                  maxDate: _maxDate,
                  onSelect: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    selectedLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(_selectedDate),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Готово'),
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
