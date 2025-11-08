class ChatDetailData {
  const ChatDetailData({
    required this.consultantName,
    required this.consultantRole,
    required this.question,
    required this.answer,
    this.avatarAsset,
  });

  final String consultantName;
  final String consultantRole;
  final String question;
  final String answer;
  final String? avatarAsset;

  const ChatDetailData.sample()
    : this(
        consultantName: 'Ольга',
        consultantRole: 'Специалист',
        question: 'Как начать заново после срыва?',
        answer:
            'Добрый день ответ на ваш вопрос\n'
            '- После срыва важно принять случившееся без самобичевания,\n'
            'проанализировать триггеры и разработать план поддержки',
        avatarAsset: 'assets/icons/avatar.png',
      );
}
