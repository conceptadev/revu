// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:mix/mix.dart';

enum AnthropicModel {
  claudeV1_3_100k('claude-v1.3-100k'),
  claudeInstantV1_1_100k('claude-instant-v1.1-100k');

  final String modelName;

  const AnthropicModel(this.modelName);

  factory AnthropicModel.fromModelName(String? name) =>
      AnthropicModel.claudeInstantV1_1_100k;
  //AnthropicModel.values
  //  .firstWhereOrNull((element) => element.modelName == name) ??
  //AnthropicModel.claudeV1_3_100k;

  @override
  String toString() => modelName;
}

const HUMAN_PROMPT = '\n\nHuman:';

class SamplingParametersDto extends Equatable {
  final String prompt;
  final double temperature;
  final int maxTokensToSample;
  final List<String> stopSequences;
  final int topK;
  final double topP;
  final AnthropicModel model;
  final Map<String, String>? tags;

  const SamplingParametersDto({
    required this.prompt,
    this.temperature = 0.3,
    this.maxTokensToSample = 10000,
    this.stopSequences = const [HUMAN_PROMPT],
    this.topK = -1,
    this.topP = -1,
    this.model = AnthropicModel.claudeV1_3_100k,
    this.tags,
  });

  factory SamplingParametersDto.fromJson(Map<String, dynamic> json) {
    return SamplingParametersDto(
      prompt: json['prompt'],
      temperature: json['temperature'],
      maxTokensToSample: json['max_tokens_to_sample'],
      stopSequences: List<String>.from(json['stop_sequences']),
      topK: json['top_k'],
      topP: json['top_p'],
      model: AnthropicModel.fromModelName(json['model']),
      tags:
          json['tags'] == null ? null : Map<String, String>.from(json['tags']),
    );
  }

  Map<String, dynamic> toJson() => {
        'prompt': prompt,
        'temperature': temperature,
        'max_tokens_to_sample': maxTokensToSample,
        'stop_sequences': stopSequences,
        'top_k': topK,
        'top_p': topP,
        'model': model.toString(),
        'tags': tags,
      };

  @override
  List<Object?> get props => [
        prompt,
        temperature,
        maxTokensToSample,
        stopSequences,
        topK,
        topP,
        model,
        tags,
      ];
}
