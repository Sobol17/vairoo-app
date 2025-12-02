class ChatDetailData {
  const ChatDetailData({
    required this.chatId,
    required this.consultantName,
    required this.consultantRole,
    this.initialQuestion = '',
    this.initialAnswer = '',
    this.avatarAsset,
  });

  final String chatId;
  final String consultantName;
  final String consultantRole;
  final String initialQuestion;
  final String initialAnswer;
  final String? avatarAsset;

  const ChatDetailData.sample()
    : this(
        chatId: 'sample-chat',
        consultantName: 'Ольга',
        consultantRole: 'Специалист',
        initialQuestion: 'Как начать заново после срыва?',
        initialAnswer:
            'Добрый день ответ на ваш вопрос\n'
            '- После срыва важно принять случившееся без самобичевания,\n'
            'проанализировать триггеры и разработать план поддержки',
        avatarAsset: 'assets/icons/avatar.png',
      );
}
