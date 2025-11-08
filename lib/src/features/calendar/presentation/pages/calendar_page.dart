import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/calendar/presentation/widgets/calendar_intro_sheet.dart';
import 'package:ai_note/src/features/calendar/presentation/widgets/calendar_tab_bar.dart';
import 'package:ai_note/src/features/plan/presentation/widgets/circular_nav_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  bool _warningShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showWarningSheet());
  }

  Future<void> _showWarningSheet() async {
    if (!mounted || _warningShown) {
      return;
    }
    _warningShown = true;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const CalendarIntroSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.bgGray,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Text(
                      'План 30 дней',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    top: 10,
                    child: CircularNavButton(
                      icon: Icons.calendar_month_outlined,
                      onPressed: () => context.push('/calendar'),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CalendarTabBar(theme: theme),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
