import 'package:equatable/equatable.dart';
import 'package:revue_app/modules/chat/enum/chat_roles.enum.dart';

class ChatMessage extends Equatable {
  final MessageRole role;

  /// Hide the message from the UI
  final bool hidden;
  final String content;
  final DateTime createdAt;

  const ChatMessage({
    required this.role,
    required this.content,
    required this.createdAt,
    this.hidden = false,
  });

  int get tokenCount {
    // return _tokenCountCache ??= TokenEstimator.estimateAverageTokens(content);
    return 0;
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
      hidden: hidden,
    );
  }

  @override
  List<Object?> get props => [
        role,
        content,
        createdAt,
        hidden,
      ];
}
