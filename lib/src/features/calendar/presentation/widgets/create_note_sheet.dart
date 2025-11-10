import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/calendar/domain/entities/calendar_note.dart';
import 'package:ai_note/src/features/calendar/presentation/widgets/calendar_bottom_sheet.dart';
import 'package:ai_note/src/features/calendar/presentation/widgets/calendar_toggle_row.dart';
import 'package:ai_note/src/features/calendar/presentation/widgets/date_pick_field.dart';
import 'package:ai_note/src/shared/constants/monts.dart';
import 'package:ai_note/src/shared/widgets/primary_button.dart';
import 'package:ai_note/src/shared/widgets/secondary_button.dart';
import 'package:ai_note/src/shared/widgets/sheet_header.dart';
import 'package:flutter/material.dart';

class CreateCalendarNoteSheet extends StatefulWidget {
  const CreateCalendarNoteSheet({super.key});

  @override
  State<CreateCalendarNoteSheet> createState() =>
      _CreateCalendarNoteSheetState();
}

class _CreateCalendarNoteSheetState extends State<CreateCalendarNoteSheet> {
  final _feelingsController = TextEditingController();
  final _thoughtsController = TextEditingController();
  final _actionsController = TextEditingController();
  final _riskDescriptionController = TextEditingController();
  final _relapseDescriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _riskEnabled = false;
  bool _relapseEnabled = false;

  @override
  void dispose() {
    _feelingsController.dispose();
    _thoughtsController.dispose();
    _actionsController.dispose();
    _riskDescriptionController.dispose();
    _relapseDescriptionController.dispose();
    super.dispose();
  }

  String get _formattedDate {
    final monthName = MONTH_NAMES[_selectedDate.month - 1];
    return '$monthName ${_selectedDate.day}, ${_selectedDate.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => PlanCalendarBottomSheet(initialDate: _selectedDate),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _toggleRisk(bool value) {
    setState(() {
      _riskEnabled = value;
      if (!value) {
        _riskDescriptionController.clear();
      }
    });
  }

  void _toggleRelapse(bool value) {
    setState(() {
      _relapseEnabled = value;
      if (!value) {
        _relapseDescriptionController.clear();
      }
    });
  }

  void _showInfoDialog(String title, String description) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Понятно'),
          ),
        ],
      ),
    );
  }

  void _handleReadArticle() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Статьи пока нет — мы уже работаем над материалами.'),
      ),
    );
  }

  void _submit() {
    final title = _buildTitle();
    final preview = _buildPreview();
    final note = CalendarNote(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      date: _selectedDate,
      title: title,
      preview: preview,
    );
    Navigator.of(context).pop(note);
  }

  String _buildTitle() {
    final candidates = [
      _feelingsController.text.trim(),
      _thoughtsController.text.trim(),
      _actionsController.text.trim(),
      if (_riskEnabled) _riskDescriptionController.text.trim(),
      if (_relapseEnabled) _relapseDescriptionController.text.trim(),
    ].where((value) => value.isNotEmpty).toList();
    if (candidates.isEmpty) {
      return 'Новая запись';
    }
    return candidates.first;
  }

  String _buildPreview() {
    final inputs = [
      _feelingsController.text.trim(),
      _thoughtsController.text.trim(),
      _actionsController.text.trim(),
      if (_riskEnabled) _riskDescriptionController.text.trim(),
      if (_relapseEnabled) _relapseDescriptionController.text.trim(),
    ].where((value) => value.isNotEmpty).toList();
    if (inputs.isEmpty) {
      return 'Запись из календаря';
    }
    return inputs.take(2).join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);
    final bottomInset = media.viewInsets.bottom;
    final sheetHeight = media.size.height - 60;

    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: SizedBox(
        height: sheetHeight,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: Container(
            color: const Color(0xFFECEAEB),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SheetHeader(
                  title: 'Заметки',
                  actionLabel: 'Отмена',
                  onAction: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            padding: EdgeInsets.only(bottom: bottomInset + 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DatePickerField(
                                  label: _formattedDate,
                                  onTap: _pickDate,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Вся информация строго конфиденциальная',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildInputField(
                                  controller: _feelingsController,
                                  hint: 'Как вы себя чувствуете?',
                                ),
                                const SizedBox(height: 12),
                                _buildInputField(
                                  controller: _thoughtsController,
                                  hint: 'Какие у вас возникают мысли?',
                                ),
                                const SizedBox(height: 12),
                                _buildInputField(
                                  controller: _actionsController,
                                  hint: 'Как вы будете действовать?',
                                ),
                                const SizedBox(height: 20),
                                ToggleRow(
                                  label: 'Ситуация повышенного риска',
                                  onInfoTap: () => _showInfoDialog(
                                    'Ситуация риска',
                                    'Отметьте, если рядом есть обстоятельства, '
                                        'которые могут привести к срыву. '
                                        'Опишите, что произошло.',
                                  ),
                                  value: _riskEnabled,
                                  onChanged: _toggleRisk,
                                ),
                                if (_riskEnabled) ...[
                                  const SizedBox(height: 12),
                                  _buildMultilineField(
                                    controller: _riskDescriptionController,
                                    hint: 'Расскажите о ситуации',
                                  ),
                                ],
                                const SizedBox(height: 20),
                                ToggleRow(
                                  label: 'Срыв',
                                  onInfoTap: () => _showInfoDialog(
                                    'Срыв',
                                    'Если произошёл срыв, расскажите об этом. '
                                        'Мы поможем с рекомендациями и '
                                        'поддержкой.',
                                  ),
                                  value: _relapseEnabled,
                                  onChanged: _toggleRelapse,
                                ),
                                if (_relapseEnabled) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    'Вы уже сделали очень много для себя, '
                                    'главное — продолжайте идти вперёд',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildMultilineField(
                                    controller: _relapseDescriptionController,
                                    hint: 'Расскажите что произошло',
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        SafeArea(
                          top: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (_riskEnabled) ...[
                                PrimaryButton(
                                  label: 'Читать статью',
                                  isLoading: false,
                                  onPressed: _handleReadArticle,
                                ),
                                const SizedBox(height: 12),
                              ],
                              SecondaryButton(
                                label: 'Создать заметку',
                                onPressed: _submit,
                              ),
                              SizedBox(height: bottomInset),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  Widget _buildMultilineField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      minLines: 4,
      maxLines: 6,
      decoration: InputDecoration(
        hintText: hint,
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}
