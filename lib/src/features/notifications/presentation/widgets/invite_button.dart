import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

class InviteToChatButton extends StatelessWidget {
  const InviteToChatButton({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(0, 0, 0, 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.textBlack,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            textStyle: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () => _handleShare(context),
          icon: SvgPicture.asset(
            'assets/icons/chat.svg',
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          label: Text(label),
        ),
      ),
    );
  }

  Future<void> _handleShare(BuildContext context) async {
    const inviteUrl = 'https://example.com/invite';
    const message = 'Приглашение, чтобы вместе работать над собой\n$inviteUrl';

    final box = context.findRenderObject() as RenderBox?;
    final shareOrigin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    await SharePlus.instance.share(
      ShareParams(
        text: message,
        subject: 'Приглашение в чат',
        sharePositionOrigin: shareOrigin,
      ),
    );
  }
}
