import 'package:equatable/equatable.dart';

enum StopReason {
  stopSequence('stop_sequence'),
  maxTokens('max_tokens');

  final String stopReason;

  const StopReason(this.stopReason);

  @override
  String toString() => stopReason;

  factory StopReason.fromString(String reason) {
    return StopReason.values.firstWhere(
      (element) => element.stopReason == reason,
    );
  }
}

class CompletionResponseDto extends Equatable {
  final String completion;
  final String? stop;
  final StopReason? stopReason;
  final bool truncated;
  final String? exception;
  final String logId;

  const CompletionResponseDto({
    required this.completion,
    this.stop,
    required this.stopReason,
    required this.truncated,
    this.exception,
    required this.logId,
  });

  factory CompletionResponseDto.fromJson(Map<String, dynamic> json) {
    return CompletionResponseDto(
      completion: json['completion'],
      stop: json['stop'],
      stopReason: json['stop_reason'] != null
          ? StopReason.fromString(json['stop_reason'])
          : null,
      truncated: json['truncated'],
      exception: json['exception'],
      logId: json['log_id'],
    );
  }

  @override
  List<Object?> get props => [
        completion,
        stop,
        stopReason,
        truncated,
        exception,
        logId,
      ];
}
