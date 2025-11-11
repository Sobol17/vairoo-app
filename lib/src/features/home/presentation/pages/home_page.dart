import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:ai_note/src/features/disclaimer/domain/entities/disclaimer_type.dart';
import 'package:ai_note/src/features/disclaimer/presentation/controllers/disclaimer_controller.dart';
import 'package:ai_note/src/features/disclaimer/presentation/pages/disclaimer_screen.dart';
import 'package:ai_note/src/features/disclaimer/presentation/widgets/main_disclaimer_dialog.dart';
import 'package:ai_note/src/features/home/data/datasources/mock_data.dart';
import 'package:ai_note/src/features/home/domain/entities/home_insight.dart';
import 'package:ai_note/src/features/home/presentation/widgets/home_daily_plan_section.dart';
import 'package:ai_note/src/features/home/presentation/widgets/home_insights_section.dart';
import 'package:ai_note/src/features/home/presentation/widgets/home_motivation_card.dart';
import 'package:ai_note/src/features/home/presentation/widgets/home_top_header.dart';
import 'package:ai_note/src/features/home/presentation/widgets/sos_button.dart';
import 'package:ai_note/src/features/notifications/domain/entities/chat_detail_data.dart';
import 'package:ai_note/src/features/plan/data/plan_samples.dart';
import 'package:ai_note/src/shared/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeView();
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureMainDisclaimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final insights = _buildInsights();

    return Scaffold(
      backgroundColor: AppColors.bgGray,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _HomeHeaderDelegate(
                  child: HomeTopHeader(
                    onChatTap: _handleChatTap,
                    onNotificationsTap: _openNotifications,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: 24, bottom: 12),
                sliver: SliverToBoxAdapter(
                  child: HomeMotivationCard(
                    quote:
                        'Сложнее всего начать действовать, все остальное зависит только от упорства',
                    sobrietyCounter: '1д 5ч 36мин',
                    sobrietyStartDate: 'Дата начала 26 июня 2025 года',
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: HomeDailyPlanSection(
                    dayLabel: '1 День',
                    planDate: DateTime(2025, 7, 26),
                    routines: mockRoutines,
                    onRoutineTap: (plan) {
                      context.push('/home/plan', extra: sampleDayPlan);
                    },
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: HomeInsightsSection(cards: insights),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 140,
                ),
              ),
            ],
          ),
          Positioned(
            left: 16,
            bottom: 95,
            child: SosButton(onTap: _openSpecialistChat),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: SecondaryButton(
                  label: "Начать день",
                  onPressed: _handleStartDayTap,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _ensureMainDisclaimer() async {
    final controller = context.read<DisclaimerController>();
    final accepted = await controller.isAccepted(DisclaimerType.main);
    if (!mounted || accepted) {
      return;
    }
    final shouldMarkAccepted =
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => const MainDisclaimerDialog(),
        ) ??
        false;
    if (shouldMarkAccepted && mounted) {
      await controller.markAccepted(DisclaimerType.main);
    } else if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _ensureMainDisclaimer();
        }
      });
    }
  }

  Future<void> _handleChatTap() async {
    final accepted = await _ensureChatDisclaimerAccepted();
    if (!accepted || !mounted) {
      return;
    }
    context.push('/home/chats');
  }

  Future<void> _openSpecialistChat() async {
    final accepted = await _ensureChatDisclaimerAccepted();
    if (!accepted || !mounted) {
      return;
    }
    context.push('/home/chat', extra: const ChatDetailData.sample());
  }

  void _openNotifications() {
    context.push('/home/notifications');
  }

  void _openArticles() {
    context.push('/articles');
  }

  void _handleStartDayTap() {
    context.push('/home/plan', extra: sampleDayPlan);
  }

  Future<bool> _ensureChatDisclaimerAccepted() async {
    final controller = context.read<DisclaimerController>();
    final accepted = await controller.isAccepted(DisclaimerType.chat);
    if (accepted) {
      return true;
    }
    final acknowledged = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => DisclaimerScreen(
        onAcknowledged: () {
          controller.markAccepted(DisclaimerType.chat);
          Navigator.of(dialogContext).pop(true);
        },
      ),
    );
    return acknowledged == true;
  }

  List<HomeInsightCardData> _buildInsights() {
    return [
      HomeInsightCardData(
        icon: Image.asset('assets/icons/money_save.png'),
        title: 'Сэкономлено средств',
        value: '200 ₽',
        subtitle: 'Ваши расходы снижаются',
      ),
      HomeInsightCardData(
        icon: Image.asset('assets/icons/top.png'),
        title: 'Достижения',
        value: 'Начало пути',
        subtitle: 'Вы начали свой путь улучшения',
        actionLabel: 'Раскрыть',
        achievements: [
          HomeAchievementDetail(
            icon: Image.asset('assets/icons/top.png'),
            title: 'Начало пути',
            subtitle: 'Вы начали свой путь улучшения',
          ),
          HomeAchievementDetail(
            icon: Image.asset('assets/icons/avatar.png'),
            title: 'Намеченный путь',
            subtitle: '7 дней позади',
          ),
          HomeAchievementDetail(
            icon: Image.asset('assets/icons/money_save.png'),
            title: 'Свободный человек',
            subtitle: '20 дней трезвости',
          ),
          HomeAchievementDetail(
            icon: Image.asset('assets/icons/articles.png'),
            title: 'Товарищ на пути',
            subtitle: 'Начали общаться в сообществе',
          ),
        ],
      ),
      HomeInsightCardData(
        icon: Image.asset('assets/icons/articles.png'),
        title: 'Библиотека знаний',
        value: 'Статьи и лайфхаки',
        subtitle: 'Узнавайте много нового',
        onTap: _openArticles,
      ),
      HomeInsightCardData(
        icon: SvgPicture.asset(
          'assets/icons/hearth.svg',
          width: 50,
          height: 50,
        ),
        title: 'Ккал',
        value: '1',
        subtitle: 'Держите себя в тонусе',
      ),
    ];
  }
}

class _HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _HomeHeaderDelegate({required this.child});

  final Widget child;
  static const double _height = 140;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _HomeHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
