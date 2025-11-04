import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    required this.monthLabel,
    required this.primary,
    required this.onPrev,
    required this.onNext,
    super.key,
  });

  final String monthLabel;
  final Color primary;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final iconSize = 28.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left_rounded),
          color: onPrev == null ? primary.withValues(alpha: 0.3) : primary,
          iconSize: iconSize,
          splashRadius: 22,
        ),
        const SizedBox(width: 8),
        Text(
          monthLabel,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded),
          color: onNext == null ? primary.withValues(alpha: 0.3) : primary,
          iconSize: iconSize,
          splashRadius: 22,
        ),
      ],
    );
  }
}

class CalendarGrid extends StatelessWidget {
  const CalendarGrid({
    required this.visibleMonth,
    required this.selectedDate,
    required this.minDate,
    required this.maxDate,
    required this.onSelect,
    super.key,
  });

  final DateTime visibleMonth;
  final DateTime? selectedDate;
  final DateTime minDate;
  final DateTime maxDate;
  final ValueChanged<DateTime>? onSelect;

  static const _weekdayLabels = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];

  @override
  Widget build(BuildContext context) {
    final year = visibleMonth.year;
    final month = visibleMonth.month;
    final firstDay = DateTime(year, month, 1);
    final firstShift = (firstDay.weekday + 6) % 7;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final totalCells = firstShift + daysInMonth;
    final rowCount = (totalCells / 7).ceil();
    final rows = <TableRow>[];

    rows.add(
      TableRow(
        children: _weekdayLabels
            .map(
              (label) => SizedBox(
                height: 32,
                child: Center(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );

    DateTime? selected = selectedDate;
    for (var row = 0; row < rowCount; row++) {
      final cells = <Widget>[];
      for (var col = 0; col < 7; col++) {
        final cellIndex = row * 7 + col;
        final dayNumber = cellIndex - firstShift + 1;
        if (dayNumber < 1 || dayNumber > daysInMonth) {
          cells.add(const SizedBox(height: 48));
          continue;
        }
        final dayDate = DateTime(year, month, dayNumber);
        final isDisabled =
            dayDate.isBefore(minDate) || dayDate.isAfter(maxDate);
        final isSelected = selected != null && _isSameDay(selected, dayDate);
        cells.add(
          SizedBox(
            height: 48,
            child: Center(
              child: InkWell(
                onTap: isDisabled || onSelect == null
                    ? null
                    : () => onSelect!(dayDate),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.secondary.withValues(alpha: 0.32)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                    border: isSelected
                        ? Border.all(color: AppColors.secondary, width: 2)
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$dayNumber',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isDisabled
                          ? AppColors.textSecondary.withValues(alpha: 0.4)
                          : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
      rows.add(TableRow(children: cells));
    }

    return Table(children: rows);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
