import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigation extends StatefulWidget {
  final int currentIndex;
  const CustomBottomNavigation({super.key, required this.currentIndex});

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  late int _currentIndex;

  String getPagePath(int index) {
    switch (index) {
      case 0:
        return '/notifications';
      case 1:
        return '/shipments';
      case 2:
        return '/profile';
      default:
        return '/profile';
    }
  }

  void _onChangePage(int index) {
    setState(() => _currentIndex = index);

    context.go(getPagePath(index));
  }

  @override
  Widget build(BuildContext context) {
    _currentIndex = widget.currentIndex;

    return BottomNavigationBar(
      unselectedItemColor: AppColors.surface,
      selectedItemColor: AppColors.accent,
      onTap: _onChangePage,
      currentIndex: _currentIndex,
      items: [
        BottomNavigationBarItem(
          activeIcon: SvgPicture.asset(
            'assets/icons/Notification-fill.svg',
            colorFilter: const ColorFilter.mode(
              AppColors.accent,
              BlendMode.srcIn,
            ),
          ),
          icon: SvgPicture.asset(
            'assets/icons/Notification-fill.svg',
            colorFilter: const ColorFilter.mode(
              AppColors.accent,
              BlendMode.srcIn,
            ),
          ),
          label: "Уведомления",
        ),
        BottomNavigationBarItem(
          activeIcon: SvgPicture.asset(
            'assets/icons/Map.svg',
            colorFilter: const ColorFilter.mode(
              AppColors.accent,
              BlendMode.srcIn,
            ),
          ),
          icon: SvgPicture.asset(
            'assets/icons/Map.svg',
            colorFilter: const ColorFilter.mode(
              AppColors.accent,
              BlendMode.srcIn,
            ),
          ),
          label: "Путевые",
        ),
        BottomNavigationBarItem(
          activeIcon: SvgPicture.asset(
            'assets/icons/Profile-fill.svg',
            colorFilter: const ColorFilter.mode(
              AppColors.accent,
              BlendMode.srcIn,
            ),
          ),
          icon: SvgPicture.asset(
            'assets/icons/Profile-fill.svg',
            colorFilter: const ColorFilter.mode(
              AppColors.accent,
              BlendMode.srcIn,
            ),
          ),
          label: "Профиль",
        ),
      ],
    );
  }
}
