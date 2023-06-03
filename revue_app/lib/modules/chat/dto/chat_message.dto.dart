import 'package:revue_app/helpers/token_estimator.dart';
import 'package:revue_app/modules/chat/enum/chat_roles.enum.dart';

class ChatMessage {
  final MessageRole role;
  final String content;
  final DateTime createdAt;
  int? _tokenCountCache;

  ChatMessage({
    required this.role,
    required this.content,
    required this.createdAt,
  });

  int get tokenCount {
    return _tokenCountCache ??= TokenEstimator.estimateAverageTokens(content);
  }

  // Returns a new instance of ChatMessage that
  ChatMessage copyWithDelta({
    String? deltaContent,
    DateTime? createdAt,
  }) {
    return ChatMessage(
      role: role,
      content: content + (deltaContent ?? ''),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
