import 'package:mix/mix.dart';

class MessageOwner extends StyleVariant {
  MessageOwner._(String name) : super(name);
  // Sizes
  static final self = MessageOwner._('message.owner.self');
  static final other = MessageOwner._('message.owner.other');
}
