import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/calendar/domain/entities/calendar_note.dart';
import 'package:ai_note/src/features/calendar/presentation/widgets/create_note_sheet.dart';
import 'package:ai_note/src/features/home/presentation/widgets/header_circle_button.dart';
import 'package:ai_note/src/shared/helpers/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

class CalendarNoteDetailPage extends StatefulWidget {
  const CalendarNoteDetailPage({
    required this.note,
    this.onUpdate,
    this.onDelete,
    super.key,
  });

  final CalendarNote note;
  final ValueChanged<CalendarNote>? onUpdate;
  final ValueChanged<CalendarNote>? onDelete;

  @override
  State<CalendarNoteDetailPage> createState() => _CalendarNoteDetailPageState();
}

class _CalendarNoteDetailPageState extends State<CalendarNoteDetailPage> {
  late CalendarNote _note;
  final _formatter = Formatter();

  @override
  void initState() {
    super.initState();
    _note = widget.note;
  }

  Future<void> _editNote() async {
    final updated = await showModalBottomSheet<CalendarNote>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => CreateCalendarNoteSheet(
        initialNote: _note,
        submitLabel: 'Сохранить изменения',
      ),
    );
    if (updated != null) {
      setState(() => _note = updated);
      widget.onUpdate?.call(updated);
    }
  }

  void _deleteNote() {
    widget.onDelete?.call(_note);
    Navigator.of(context).pop();
  }

  void _shareNote() {
    final parts = <String>[
      _note.title,
      _formatter.formatFullDate(_note.date),
      if (_note.feelings.isNotEmpty) _note.feelings,
      if (_note.thoughts.isNotEmpty) _note.thoughts,
      if (_note.actions.isNotEmpty) _note.actions,
      if (_note.isRisk && (_note.riskDescription?.isNotEmpty ?? false))
        _note.riskDescription!,
      if (_note.isRelapse && (_note.relapseDescription?.isNotEmpty ?? false))
        _note.relapseDescription!,
    ];
    SharePlus.instance.share(ShareParams(text: parts.join('\n\n')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DetailHeader(
              title: _note.title,
              onBack: () => Navigator.of(context).pop(),
              onShare: _shareNote,
              onDelete: _deleteNote,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatter.formatFullDate(_note.date),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ..._buildSections(theme),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: FilledButton.icon(
                  onPressed: _editNote,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    textStyle: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Редактировать'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSections(ThemeData theme) {
    final sections = <Widget>[];

    void addSection(String title, String value) {
      if (value.trim().isEmpty) return;
      sections.add(
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
      sections.add(const SizedBox(height: 8));
      sections.add(
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.5,
            color: AppColors.textPrimary,
          ),
        ),
      );
      sections.add(const SizedBox(height: 20));
    }

    addSection('Как вы себя чувствуете?', _note.feelings);
    addSection('Какие у вас возникают мысли?', _note.thoughts);
    addSection('Как вы будете действовать?', _note.actions);

    if (_note.isRisk && (_note.riskDescription?.isNotEmpty ?? false)) {
      sections.add(
        _HighlightedSection(
          title: 'Ситуация повышенного риска',
          description: _note.riskDescription ?? '',
          color: AppColors.secondaryLight,
        ),
      );
      sections.add(const SizedBox(height: 20));
    }

    if (_note.isRelapse) {
      sections.add(
        _HighlightedSection(
          title: 'Срыв',
          description:
              _note.relapseDescription ??
              'Вы уже сделали очень много для себя, главное — продолжайте идти вперёд.',
          color: AppColors.accentLight,
        ),
      );
      sections.add(const SizedBox(height: 20));
    }

    if (sections.isEmpty) {
      sections.add(
        Text(
          'Запись пока пустая. Добавьте детали, чтобы отслеживать прогресс.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return sections;
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({
    required this.title,
    required this.onBack,
    required this.onShare,
    required this.onDelete,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 16, 12),
      child: SizedBox(
        height: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.chevron_left_rounded, size: 20),
                label: const Text('Назад'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  textStyle: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HeaderCircleButton(
                    color: AppColors.secondary.withValues(alpha: 0.2),
                    icon: SvgPicture.asset(
                      'assets/icons/backet.svg',
                      colorFilter: ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightedSection extends StatelessWidget {
  const _HighlightedSection({
    required this.title,
    required this.description,
    required this.color,
  });

  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.4,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
