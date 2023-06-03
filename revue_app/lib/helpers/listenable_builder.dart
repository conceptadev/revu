import 'package:flutter/material.dart';

class MultiListenableBuilder extends ListenableBuilder {
  MultiListenableBuilder({
    super.key,
    required super.builder,
    Listenable? listenable,
    List<Listenable>? listenables,
    super.child,
  })  : assert(listenable == null || listenables == null),
        super(
          listenable: Listenable.merge(listenables ?? [listenable]),
        );
}
