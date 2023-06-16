import 'package:revue_app/modules/chat/enum/chat_roles.enum.dart';
import 'package:sp_ai_simple_bpe_tokenizer/utilities/sp_ai_simple_bpe_tokenizer.dart';

class ChatMessage {
  final MessageRole role;

  /// Hide the message from the UI
  final bool hidden;
  final String content;
  final DateTime createdAt;
  int? _tokenCountCache;

  ChatMessage({
    required this.role,
    required this.content,
    required this.createdAt,
    this.hidden = false,
  });

  Future<int> getTokenCount() async {
    if (_tokenCountCache != null) {
      return _tokenCountCache!;
    }
    final container = await SPAiSimpleBpeTokenizer().encodeString(content);
    if (container.tokenCount == null) {
      return 0;
    } else {
      _tokenCountCache = container.tokenCount!;
      return _tokenCountCache!;
    }
  }

  ChatMessage copyWith({
    String? content,
    DateTime? createdAt,
  }) {
    return ChatMessage(
      role: role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      hidden: hidden,
    );
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
}
