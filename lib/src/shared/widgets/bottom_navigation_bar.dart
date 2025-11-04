import 'package:ai_note/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      unselectedItemColor: AppColors.secondary,
      selectedItemColor: AppColors.secondary,
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      elevation: 1,
      onTap: onDestinationSelected,
      items: [
        BottomNavigationBarItem(
          activeIcon: SvgPicture.asset('assets/icons/navigation/home_fill.svg'),
          icon: SvgPicture.asset('assets/icons/navigation/home.svg'),
          label: 'Главная',
        ),
        BottomNavigationBarItem(
          activeIcon: SvgPicture.asset(
            'assets/icons/navigation/cloud_fill.svg',
          ),
          icon: SvgPicture.asset('assets/icons/navigation/cloud.svg'),
          label: 'Практика',
        ),
        BottomNavigationBarItem(
          activeIcon: SvgPicture.asset(
            'assets/icons/navigation/calendar_fill.svg',
          ),
          icon: SvgPicture.asset('assets/icons/navigation/calendar.svg'),
          label: 'Календарь',
        ),
        BottomNavigationBarItem(
          activeIcon: SvgPicture.asset(
            'assets/icons/navigation/profile_fill.svg',
          ),
          icon: SvgPicture.asset('assets/icons/navigation/profile.svg'),
          label: 'Профиль',
        ),
      ],
    );
  }
}
