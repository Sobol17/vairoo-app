import 'package:equatable/equatable.dart';

enum ChatAttachmentType { image, audio, video, file, other }

class ChatAttachment extends Equatable {
  const ChatAttachment({
    required this.url,
    required this.type,
  });

  final String url;
  final ChatAttachmentType type;

  @override
  List<Object?> get props => [url, type];
}
