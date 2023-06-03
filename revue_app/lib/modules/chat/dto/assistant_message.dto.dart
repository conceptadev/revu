import 'package:revue_app/modules/chat/dto/message.dto.dart';
import 'package:revue_app/modules/chat/enum/chat_roles.enum.dart';

class AssistantMessageDto extends MessageDto {
  AssistantMessageDto({
    required super.content,
  }) : super(role: MessageRole.assistant);
}
