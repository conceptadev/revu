import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:revue_app/components/molecules/bubble/bubble.variants.dart';

final messageBubbleStyle = StyleMix(
  mainAxisAlignment(MainAxisAlignment.start),
  MessageOwner.self(
    mainAxisAlignment(MainAxisAlignment.end),
  ),
);

final messageStyle = StyleMix(
  paddingSymmetric(vertical: 12, horizontal: 14),
);
