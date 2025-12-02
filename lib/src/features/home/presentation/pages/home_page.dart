import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:Vairoo/src/features/disclaimer/domain/entities/disclaimer_type.dart';
import 'package:Vairoo/src/features/disclaimer/presentation/controllers/disclaimer_controller.dart';
import 'package:Vairoo/src/features/disclaimer/presentation/pages/disclaimer_screen.dart';
import 'package:Vairoo/src/features/disclaimer/presentation/widgets/main_disclaimer_dialog.dart';
import 'package:Vairoo/src/features/home/domain/entities/home_insight.dart';
import 'package:Vairoo/src/features/home/domain/entities/home_plan.dart';
import 'package:Vairoo/src/features/home/presentation/controllers/home_controller.dart';
import 'package:Vairoo/src/features/home/presentation/widgets/home_daily_plan_section.dart';
import 'package:Vairoo/src/features/home/presentation/widgets/home_insights_section.dart';
import 'package:Vairoo/src/features/home/presentation/widgets/home_motivation_card.dart';
import 'package:Vairoo/src/features/home/presentation/widgets/home_top_header.dart';
import 'package:Vairoo/src/features/home/presentation/widgets/sos_button.dart';
import 'package:Vairoo/src/features/notifications/domain/entities/chat_detail_data.dart';
import 'package:Vairoo/src/features/plan/domain/entities/daily_plan.dart';
import 'package:Vairoo/src/features/plan/domain/repositories/plan_repository.dart';
import 'package:Vairoo/src/features/practice/domain/entities/practice_tab.dart';
import 'package:Vairoo/src/shared/widgets/secondary_button.dart';
import 'package:dio/dio.dart';
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
  bool _requestedLoad = false;
  bool _isStartingDay = false;
  bool _hasActivePlan = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureMainDisclaimer();
      _loadHome();
    });
  }

  Future<void> _loadHome() async {
    if (_requestedLoad) {
      return;
    }
    _requestedLoad = true;
    await context.read<HomeController>().loadHome();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();
    final insights = _buildInsights(controller, _openArticles);
    final isLoading = controller.isLoading;
    final hasData = controller.data != null;
    final errorMessage = controller.errorMessage;

    if (!hasData && isLoading) {
      return Scaffold(
        backgroundColor: AppColors.bgGray,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (!hasData && errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.bgGray,
        body: Center(child: Text(errorMessage, textAlign: TextAlign.center)),
      );
    }

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
                    quote: controller.quote,
                    sobrietyCounter: controller.sobrietyCounter,
                    sobrietyStartDate: controller.sobrietyStartLabel,
                  ),
                ),
              ),
              if (controller.routines.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: HomeDailyPlanSection(
                      dayLabel: controller.dayLabel,
                      planDate: controller.planDate,
                      routines: controller.routines,
                      isPlanStarted: _hasActivePlan,
                      onRoutineTap: _handlePlanCardTap,
                    ),
                  ),
                )
              else
                const SliverPadding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: _CompletedPlanBanner(),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: HomeInsightsSection(
                    todayCards: insights.todayCards,
                    totalCards: insights.totalCards,
                  ),
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
            child: SosButton(
              onCalmingTap: _openCalmingPractice,
              onGamesTap: _openPracticeGames,
              onChatTap: _openSpecialistChat,
            ),
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
                  label: _hasActivePlan ? 'План дня' : 'Начать день',
                  onPressed: _isStartingDay ? null : _handleStartDayTap,
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

  void _openCalmingPractice() {
    context.go('/practice', extra: PracticeTab.calming);
  }

  void _openPracticeGames() {
    context.go('/practice', extra: PracticeTab.games);
  }

  void _openNotifications() {
    context.push('/home/notifications');
  }

  void _openArticles() {
    context.push('/articles');
  }

  void _handleStartDayTap() {
    _startDayAndOpenPlan();
  }

  void _handlePlanCardTap(HomeRoutinePlan plan) {
    _startDayAndOpenPlan();
  }

  Future<void> _startDayAndOpenPlan() async {
    if (_isStartingDay) {
      return;
    }
    setState(() {
      _isStartingDay = true;
    });
    try {
      final planRepository = context.read<PlanRepository>();
      final plan = await _fetchExistingOrStartPlan(planRepository);
      if (!mounted) {
        return;
      }
      context.push('/home/plan', extra: plan);
    } catch (error) {
      if (!mounted) {
        return;
      }
      final message = _mapPlanStartError(error);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _isStartingDay = false;
        });
      }
    }
  }

  Future<DailyPlan> _fetchExistingOrStartPlan(PlanRepository repository) async {
    try {
      final plan = await repository.fetchCurrentPlan();
      _markPlanStarted(plan);
      return plan;
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        final plan = await repository.startPlan();
        _markPlanStarted(plan);
        return plan;
      }
      rethrow;
    }
  }

  void _markPlanStarted(DailyPlan plan) {
    if (!mounted) {
      _hasActivePlan = true;
      return;
    }
    setState(() {
      _hasActivePlan = true;
    });
  }

  String _mapPlanStartError(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['detail'] ?? data['message'] ?? data['error'];
        if (message is String && message.isNotEmpty) {
          return message;
        }
      }
      return error.message ?? 'Не удалось начать день';
    }
    return 'Не удалось начать день';
  }

  Future<bool> _ensureChatDisclaimerAccepted() async {
    final controller = context.read<DisclaimerController>();
    final accepted = await controller.isAccepted(DisclaimerType.chat);
    if (accepted) {
      return true;
    }
    if (!mounted) {
      return false;
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

  _InsightsTabsData _buildInsights(
    HomeController controller,
    VoidCallback onArticlesTap,
  ) {
    final data = controller.data;
    if (data == null) {
      return _buildFallbackInsights(onArticlesTap);
    }

    final achievements = data.achievements
        .map(
          (achievement) => HomeAchievementDetail(
            icon: Image.asset('assets/icons/avatar.png'),
            title: achievement.title,
            subtitle: achievement.description,
          ),
        )
        .toList(growable: false);
    final knowledge = data.knowledge
        .map(
          (item) => HomeAchievementDetail(
            icon: Image.asset('assets/icons/articles.png'),
            title: item.title,
            subtitle: item.description,
          ),
        )
        .toList(growable: false);

    final trailingCards = <HomeInsightCardData>[];
    if (achievements.isNotEmpty) {
      trailingCards.add(
        HomeInsightCardData(
          icon: Image.asset('assets/icons/top.png'),
          title: 'Достижения',
          value: achievements.first.title,
          subtitle: achievements.first.subtitle,
          actionLabel: 'Раскрыть',
          achievements: achievements,
        ),
      );
    }
    trailingCards.addAll([
      HomeInsightCardData(
        icon: Image.asset('assets/icons/articles.png'),
        title: 'Библиотека знаний',
        value: knowledge.isNotEmpty ? knowledge.first.title : 'Чтение дня',
        subtitle: knowledge.isNotEmpty
            ? knowledge.first.subtitle
            : 'Читайте статьи и лайфхаки',
        onTap: onArticlesTap,
      ),
      HomeInsightCardData(
        icon: SvgPicture.asset(
          'assets/icons/hearth.svg',
          width: 50,
          height: 50,
        ),
        title: data.calories.title.isNotEmpty ? data.calories.title : 'Ккал',
        value: data.calories.value,
        subtitle: data.calories.description,
      ),
    ]);

    final todayCards = [
      _buildSavingsCard(
        value: '${data.savings.amount} ${data.savings.currency}',
        subtitle: data.savings.caption,
      ),
      ...trailingCards,
    ];

    final totalValue = data.totalSaved.isNotEmpty
        ? '${data.totalSaved} ${data.savings.currency}'
        : '${data.savings.amount} ${data.savings.currency}';
    final totalCards = [
      _buildSavingsCard(
        value: totalValue,
        subtitle: data.savings.caption,
      ),
      ...trailingCards,
    ];

    return _InsightsTabsData(
      todayCards: todayCards,
      totalCards: totalCards,
    );
  }

  _InsightsTabsData _buildFallbackInsights(VoidCallback onArticlesTap) {
    final achievements = [
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
    ];
    final trailingCards = [
      HomeInsightCardData(
        icon: Image.asset('assets/icons/top.png'),
        title: 'Достижения',
        value: 'Вы начали свой путь улучшения',
        subtitle: 'Продолжайте выполнять задания',
        actionLabel: 'Раскрыть',
        achievements: achievements,
      ),
      HomeInsightCardData(
        icon: Image.asset('assets/icons/articles.png'),
        title: 'Библиотека знаний',
        value: 'Статьи и лайфхаки',
        subtitle: 'Узнавайте много нового',
        onTap: onArticlesTap,
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

    final todayCards = [
      _buildSavingsCard(value: '200 ₽', subtitle: 'Ваши расходы снижаются'),
      ...trailingCards,
    ];
    final totalCards = [
      _buildSavingsCard(value: '1000 ₽', subtitle: 'Ваши расходы снижаются'),
      ...trailingCards,
    ];

    return _InsightsTabsData(
      todayCards: todayCards,
      totalCards: totalCards,
    );
  }

  HomeInsightCardData _buildSavingsCard({
    required String value,
    required String subtitle,
  }) {
    return HomeInsightCardData(
      icon: Image.asset('assets/icons/money_save.png'),
      title: 'Сэкономлено средств',
      value: value,
      subtitle: subtitle.isNotEmpty ? subtitle : 'Ваши расходы снижаются',
    );
  }
}

class _InsightsTabsData {
  const _InsightsTabsData({
    required this.todayCards,
    required this.totalCards,
  });

  final List<HomeInsightCardData> todayCards;
  final List<HomeInsightCardData> totalCards;
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

class _CompletedPlanBanner extends StatelessWidget {
  const _CompletedPlanBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        'Сегодня вы выполнили весь план. Отправляйтесь отдыхать',
        style: theme.textTheme.titleMedium?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      ),
    );
  }
}
