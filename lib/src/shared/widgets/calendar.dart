import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    required this.monthLabel,
    required this.primary,
    required this.onPrev,
    required this.onNext,
    this.year,
    this.minYear,
    this.maxYear,
    this.onYearChanged,
    super.key,
  });

  final String monthLabel;
  final Color primary;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final int? year;
  final int? minYear;
  final int? maxYear;
  final ValueChanged<int>? onYearChanged;

  bool get _canPickYear =>
      year != null &&
      minYear != null &&
      maxYear != null &&
      onYearChanged != null &&
      minYear! <= maxYear!;

  @override
  Widget build(BuildContext context) {
    final iconSize = 28.0;
    final label = _buildLabel(context);

    return Row(
      children: [
        IconButton(
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left_rounded),
          color: onPrev == null ? primary.withValues(alpha: 0.3) : primary,
          iconSize: iconSize,
          splashRadius: 22,
        ),
        Expanded(child: Center(child: label)),
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

  Widget _buildLabel(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: primary,
    );

    if (!_canPickYear) {
      return Text(
        monthLabel,
        style: textStyle,
        overflow: TextOverflow.ellipsis,
      );
    }

    return IntrinsicWidth(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              monthLabel,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          _YearDropdown(
            year: year!,
            minYear: minYear!,
            maxYear: maxYear!,
            onChanged: onYearChanged!,
          ),
        ],
      ),
    );
  }
}

enum CalendarSelectionMode { single, range }

class CalendarGrid extends StatelessWidget {
  const CalendarGrid({
    required this.visibleMonth,
    required this.selectedDate,
    required this.minDate,
    required this.maxDate,
    required this.onSelect,
    this.selectionMode = CalendarSelectionMode.single,
    this.rangeStart,
    this.rangeEnd,
    super.key,
  });

  final DateTime visibleMonth;
  final DateTime? selectedDate;
  final DateTime minDate;
  final DateTime maxDate;
  final ValueChanged<DateTime>? onSelect;
  final CalendarSelectionMode selectionMode;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;

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
    final rangeBounds = _computeRangeBounds(rangeStart, rangeEnd);
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

        final dayCell = _DayCell(
          day: dayNumber,
          date: dayDate,
          isDisabled: isDisabled,
          isSelected: selected != null && _isSameDay(selected, dayDate),
          selectionMode: selectionMode,
          rangeStart: rangeStart,
          rangeEnd: rangeEnd,
          rangeBounds: rangeBounds,
          theme: Theme.of(context),
          onSelect: isDisabled || onSelect == null
              ? null
              : () => onSelect!(dayDate),
        );

        cells.add(dayCell);
      }
      rows.add(TableRow(children: cells));
    }

    return Table(children: rows);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  _RangeBounds? _computeRangeBounds(DateTime? start, DateTime? end) {
    if (selectionMode != CalendarSelectionMode.range || start == null) {
      return null;
    }
    if (end == null) {
      return _RangeBounds(start: start, end: null);
    }
    var lower = start;
    var upper = end;
    if (end.isBefore(start)) {
      lower = end;
      upper = start;
    }
    if (_isSameDay(lower, upper)) {
      return _RangeBounds(start: lower, end: lower);
    }
    return _RangeBounds(start: lower, end: upper);
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.date,
    required this.isDisabled,
    required this.isSelected,
    required this.selectionMode,
    required this.rangeStart,
    required this.rangeEnd,
    required this.rangeBounds,
    required this.theme,
    required this.onSelect,
  });

  final int day;
  final DateTime date;
  final bool isDisabled;
  final bool isSelected;
  final CalendarSelectionMode selectionMode;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final _RangeBounds? rangeBounds;
  final ThemeData theme;
  final VoidCallback? onSelect;

  bool get _isRangeMode => selectionMode == CalendarSelectionMode.range;

  bool get _isRangeStart =>
      _isRangeMode && rangeStart != null && _isSameDay(rangeStart!, date);

  bool get _isRangeEnd =>
      _isRangeMode && rangeEnd != null && _isSameDay(rangeEnd!, date);

  bool get _hasFullRange =>
      _isRangeMode &&
      rangeBounds != null &&
      rangeBounds!.end != null &&
      !rangeBounds!.start.isAtSameMomentAs(rangeBounds!.end!);

  bool get _isWithinRange {
    if (!_hasFullRange || rangeBounds == null) {
      return false;
    }
    final lower = rangeBounds!.start;
    final upper = rangeBounds!.end!;
    return date.isAfter(lower) && date.isBefore(upper);
  }

  @override
  Widget build(BuildContext context) {
    final highlightColor = AppColors.secondary.withValues(alpha: 0.18);
    final isSingleSelected = !_isRangeMode && isSelected && !isDisabled;

    final textColor = _resolveTextColor();
    final fontWeight = (isSingleSelected || _isRangeStart || _isRangeEnd)
        ? FontWeight.w700
        : FontWeight.w500;

    return SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_shouldPaintRangeBackground)
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 36,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: highlightColor,
                  borderRadius: _rangeBackgroundRadius,
                ),
              ),
            ),
          Center(
            child: InkWell(
              onTap: onSelect,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _indicatorColor,
                  borderRadius: BorderRadius.circular(24),
                  border: _indicatorBorder,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$day',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: textColor,
                    fontWeight: fontWeight,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get _shouldPaintRangeBackground {
    if (!_isRangeMode || rangeBounds == null) {
      return false;
    }
    if (_isRangeStart && _isRangeEnd) {
      return false;
    }
    return _isWithinRange ||
        (_hasFullRange && _isRangeStart) ||
        (_hasFullRange && _isRangeEnd);
  }

  BorderRadius get _rangeBackgroundRadius {
    if (!_hasFullRange || rangeBounds == null) {
      return BorderRadius.circular(16);
    }
    if (_isRangeStart && !_isRangeEnd) {
      return const BorderRadius.horizontal(
        left: Radius.circular(24),
        right: Radius.circular(12),
      );
    }
    if (_isRangeEnd && !_isRangeStart) {
      return const BorderRadius.horizontal(
        left: Radius.circular(12),
        right: Radius.circular(24),
      );
    }
    return BorderRadius.circular(12);
  }

  Color get _indicatorColor {
    if (_isRangeMode) {
      if (_isRangeStart || _isRangeEnd) {
        return AppColors.secondary;
      }
      if (_isWithinRange) {
        return Colors.transparent;
      }
    }
    if (isSelected) {
      return AppColors.secondary.withValues(alpha: 0.32);
    }
    return Colors.transparent;
  }

  Border? get _indicatorBorder {
    if (_isRangeMode) {
      return null;
    }
    if (isSelected) {
      return Border.all(color: AppColors.secondary, width: 2);
    }
    return null;
  }

  Color _resolveTextColor() {
    if (isDisabled) {
      return AppColors.textSecondary.withValues(alpha: 0.3);
    }
    if (_isRangeMode && (_isRangeStart || _isRangeEnd)) {
      return Colors.white;
    }
    if (isSelected && !_isRangeMode) {
      return AppColors.secondary;
    }
    if (_isWithinRange) {
      return AppColors.secondary;
    }
    return AppColors.textPrimary;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _RangeBounds {
  const _RangeBounds({required this.start, this.end});

  final DateTime start;
  final DateTime? end;
}

class _YearDropdown extends StatelessWidget {
  const _YearDropdown({
    required this.year,
    required this.minYear,
    required this.maxYear,
    required this.onChanged,
  });

  final int year;
  final int minYear;
  final int maxYear;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final safeYear = year < minYear
        ? minYear
        : year > maxYear
        ? maxYear
        : year;
    final items = [for (var value = maxYear; value >= minYear; value--) value];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outline),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: safeYear,
          items: items
              .map(
                (value) => DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    '$value',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null && value != safeYear) {
              onChanged(value);
            }
          },
          isDense: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: AppColors.textPrimary,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
