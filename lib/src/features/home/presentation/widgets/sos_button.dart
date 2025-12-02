import 'package:Vairoo/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SosButton extends StatefulWidget {
  const SosButton({
    super.key,
    required this.onCalmingTap,
    required this.onGamesTap,
    required this.onChatTap,
  });

  final VoidCallback onCalmingTap;
  final VoidCallback onGamesTap;
  final VoidCallback onChatTap;

  @override
  State<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends State<SosButton> with TickerProviderStateMixin {
  bool _isExpanded = false;

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _handleAction(VoidCallback callback) {
    callback();
    if (_isExpanded && mounted) {
      setState(() => _isExpanded = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mainLabelStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: Colors.white,
      letterSpacing: 0.5,
    );
    final actionLabelStyle = theme.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );

    return SizedBox(
      height: 52,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SosToggleButton(
            labelStyle: mainLabelStyle,
            isActive: _isExpanded,
            onPressed: _toggle,
          ),
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: _isExpanded
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 12),
                        _SosOptionButton(
                          label: 'Успокоение',
                          textStyle: actionLabelStyle,
                          isPill: true,
                          onTap: () => _handleAction(widget.onCalmingTap),
                        ),
                        const SizedBox(width: 12),
                        _SosOptionButton(
                          label: 'Игры',
                          textStyle: actionLabelStyle,
                          onTap: () => _handleAction(widget.onGamesTap),
                        ),
                        const SizedBox(width: 12),
                        _SosOptionButton(
                          label: 'Чат',
                          textStyle: actionLabelStyle,
                          onTap: () => _handleAction(widget.onChatTap),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SosToggleButton extends StatelessWidget {
  const _SosToggleButton({
    required this.labelStyle,
    required this.onPressed,
    required this.isActive,
  });

  final TextStyle? labelStyle;
  final VoidCallback onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
            boxShadow: isActive
                ? const [
                    BoxShadow(
                      color: Color(0x33FF5454),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Center(child: Text('SOS', style: labelStyle)),
        ),
      ),
    );
  }
}

class _SosOptionButton extends StatelessWidget {
  const _SosOptionButton({
    required this.label,
    required this.textStyle,
    required this.onTap,
    this.isPill = false,
  });

  final String label;
  final TextStyle? textStyle;
  final VoidCallback onTap;
  final bool isPill;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(26);
    final decoration = isPill
        ? BoxDecoration(color: AppColors.secondary, borderRadius: borderRadius)
        : const BoxDecoration(
            color: AppColors.secondary,
            shape: BoxShape.circle,
          );

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Ink(
          height: 52,
          width: isPill ? null : 52,
          padding: EdgeInsets.symmetric(horizontal: isPill ? 24 : 0),
          decoration: decoration,
          child: Center(child: Text(label, style: textStyle)),
        ),
      ),
    );
  }
}
