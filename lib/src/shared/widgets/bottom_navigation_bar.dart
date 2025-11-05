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
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 0,
      selectedItemColor: AppColors.secondary,
      unselectedItemColor: AppColors.secondary.withOpacity(0.6),
      currentIndex: currentIndex,
      onTap: onDestinationSelected,
      items: const [
        BottomNavigationBarItem(
          icon: _NavIcon(
            asset: 'assets/icons/navigation/home.svg',
            activeAsset: 'assets/icons/navigation/home_fill.svg',
          ),
          activeIcon: _NavIcon(
            asset: 'assets/icons/navigation/home.svg',
            activeAsset: 'assets/icons/navigation/home_fill.svg',
            isActive: true,
          ),
          label: 'Главная',
        ),
        BottomNavigationBarItem(
          icon: _NavIcon(
            asset: 'assets/icons/navigation/cloud.svg',
            activeAsset: 'assets/icons/navigation/cloud_fill.svg',
          ),
          activeIcon: _NavIcon(
            asset: 'assets/icons/navigation/cloud.svg',
            activeAsset: 'assets/icons/navigation/cloud_fill.svg',
            isActive: true,
          ),
          label: 'Практика',
        ),
        BottomNavigationBarItem(
          icon: _NavIcon(
            asset: 'assets/icons/navigation/calendar.svg',
            activeAsset: 'assets/icons/navigation/calendar_fill.svg',
          ),
          activeIcon: _NavIcon(
            asset: 'assets/icons/navigation/calendar.svg',
            activeAsset: 'assets/icons/navigation/calendar_fill.svg',
            isActive: true,
          ),
          label: 'Календарь',
        ),
        BottomNavigationBarItem(
          icon: _NavIcon(
            asset: 'assets/icons/navigation/profile.svg',
            activeAsset: 'assets/icons/navigation/profile_fill.svg',
          ),
          activeIcon: _NavIcon(
            asset: 'assets/icons/navigation/profile.svg',
            activeAsset: 'assets/icons/navigation/profile_fill.svg',
            isActive: true,
          ),
          label: 'Профиль',
        ),
      ],
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.asset,
    required this.activeAsset,
    this.isActive = false,
  });

  final String asset;
  final String activeAsset;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final iconColor = IconTheme.of(context).color ?? AppColors.secondary;
    final icon = SvgPicture.asset(
      isActive ? activeAsset : asset,
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
    );

    if (!isActive) {
      return icon;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.16),
        borderRadius: BorderRadius.circular(32),
      ),
      child: icon,
    );
  }
}
