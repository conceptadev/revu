import 'package:revue_app/modules/chat/enum/chat_roles.enum.dart';

abstract class MessageDto {
  MessageDto({
    required this.content,
    required this.role,
  });

  final String content;
  final MessageRole role;
}
