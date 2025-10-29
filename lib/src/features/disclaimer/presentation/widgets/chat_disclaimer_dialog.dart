import 'package:flutter/material.dart';

class ChatDisclaimerDialog extends StatelessWidget {
  const ChatDisclaimerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w800,
      color: const Color(0xFFFFF6F0),
    );
    final sectionTitleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: const Color(0xFFDAF5FF),
    );
    final bodyStyle = theme.textTheme.bodyMedium?.copyWith(
      height: 1.45,
      color: const Color(0xFFE7FBFF),
    );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F6C7F),
              Color(0xFF005B6B),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text('ПРАВИЛА ЧАТА', style: titleStyle),
                ),
                const SizedBox(height: 24),
                Text('Основные принципы:', style: sectionTitleStyle),
                const SizedBox(height: 8),
                _NumberedText(
                  number: 1,
                  text:
                      'Уважение. Никаких оскорблений, унижений, дискриминации и агрессии.',
                  style: bodyStyle,
                ),
                _NumberedText(
                  number: 2,
                  text:
                      'Конфиденциальность. Не разглашайте личную информацию других участников.',
                  style: bodyStyle,
                ),
                _NumberedText(
                  number: 3,
                  text:
                      'Без рекламы. Запрещены ссылки на сторонние ресурсы, коммерческие предложения и спам.',
                  style: bodyStyle,
                ),
                const SizedBox(height: 20),
                Text('Что нельзя отправлять:', style: sectionTitleStyle),
                const SizedBox(height: 8),
                _BulletText(
                  text:
                      'Фотографии, видео, голосовые сообщения. Ссылки на любые сайты, соцсети или мессенджеры.',
                  style: bodyStyle,
                ),
                _BulletText(
                  text: 'Рекламу, пропаганду или спам.',
                  style: bodyStyle,
                ),
                const SizedBox(height: 20),
                Text('Важные дополнения:', style: sectionTitleStyle),
                const SizedBox(height: 8),
                _BulletText(
                  text:
                      'Не давайте советы «выпить немного». Мы поддерживаем только полный отказ.',
                  style: bodyStyle,
                ),
                _BulletText(
                  text: 'Не осуждайте чужой опыт. У каждого свой путь к трезвости.',
                  style: bodyStyle,
                ),
                _BulletText(
                  text:
                      'Не занимайтесь самолечением. Вопросы о медикаментах решайте с врачом.',
                  style: bodyStyle,
                ),
                _BulletText(
                  text:
                      'Будьте здесь. Поддерживайте друг друга — это главная цель чата.',
                  style: bodyStyle,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Нарушение правил ведёт к предупреждению или бану.',
                    style: bodyStyle?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFFF6F0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF30D5C8),
                    foregroundColor: const Color(0xFF00444F),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Продолжить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NumberedText extends StatelessWidget {
  const _NumberedText({
    required this.number,
    required this.text,
    required this.style,
  });

  final int number;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: style,
          children: [
            TextSpan(
              text: '$number. ',
              style: style?.copyWith(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: text),
          ],
        ),
      ),
    );
  }
}

class _BulletText extends StatelessWidget {
  const _BulletText({
    required this.text,
    required this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: style,
          children: [
            TextSpan(
              text: '• ',
              style: style?.copyWith(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: text),
          ],
        ),
      ),
    );
  }
}
