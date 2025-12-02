import 'package:Vairoo/src/shared/widgets/link_chip.dart';
import 'package:flutter/material.dart';

class DisclaimerText extends StatelessWidget {
  const DisclaimerText({
    required this.textStyle,
    required this.linkStyle,
    required this.onPrivacyTap,
    required this.onPersonalPolicyTap,
    super.key,
  });

  final TextStyle textStyle;
  final TextStyle linkStyle;
  final VoidCallback onPrivacyTap;
  final VoidCallback onPersonalPolicyTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 4,
      children: [
        Text('Нажимая «Начать» вы соглашаетесь с', style: textStyle),
        LinkChip(
          label: 'Политикой конфиденциальности',
          style: linkStyle,
          onTap: onPrivacyTap,
        ),
        Text('и', style: textStyle),
        LinkChip(
          label: 'Политикой обработки персональных данных',
          style: linkStyle,
          onTap: onPersonalPolicyTap,
        ),
      ],
    );
  }
}
