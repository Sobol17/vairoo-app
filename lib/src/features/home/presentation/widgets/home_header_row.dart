import 'package:ai_note/src/features/auth/presentation/widgets/brand_logo.dart';
import 'package:ai_note/src/features/home/presentation/widgets/header_circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeHeaderRow extends StatelessWidget {
  const HomeHeaderRow({
    required this.onNotificationsTap,
    required this.onChatTap,
    super.key,
  });

  final VoidCallback onNotificationsTap;
  final VoidCallback onChatTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderCircleButton(
          icon: SvgPicture.asset(
            'assets/icons/chat.svg',
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onTap: onChatTap,
        ),
        const Spacer(),
        BrandLogo(color: Colors.white),
        const Spacer(),
        HeaderCircleButton(
          icon: SvgPicture.asset(
            'assets/icons/notification.svg',
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onTap: onNotificationsTap,
        ),
      ],
    );
  }
}
