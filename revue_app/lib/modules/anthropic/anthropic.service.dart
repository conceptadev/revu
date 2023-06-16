import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:revue_app/env/env.dart';
import 'package:revue_app/modules/anthropic/dto/completion_response.dto.dart';
import 'package:revue_app/modules/anthropic/dto/sampling_params.dto.dart';
import 'package:revue_app/modules/anthropic/exceptions/completion_exceptions.dart';

enum Event { ping }

// ignore: constant_identifier_names
const DONE_MESSAGE = "[DONE]";

// CancellationToken class implementation
class CancellationToken {
  bool _isCancelled = false;

  bool get isCancelled => _isCancelled;

  void addListener(void Function() callback) {
    if (_isCancelled) {
      callback();
    }
  }

  void cancel() {
    _isCancelled = true;
  }
}

// Rest of the code remains unchanged

class AnthropicClient {
  final String apiKey;
  String apiUrl;

  static const String anthropicVersion = '2023-01-01';
  static const String defaultApiUrl = 'https://api.anthropic.com';

  AnthropicClient({String? apiKey, String? apiUrl})
      : apiUrl = apiUrl ?? defaultApiUrl,
        apiKey = apiKey ?? Env.anthropicApiKey;

  Future<CompletionResponseDto> complete(
    SamplingParametersDto params, {
    CancellationToken? cancellationToken,
  }) async {
    // Create a completer to manage cancellation
    final completer = Completer<http.Response>();

    // Check cancellationToken to cancel request if needed
    cancellationToken?.addListener(() {
      if (cancellationToken.isCancelled && !completer.isCompleted) {
        completer.completeError(AbortError('Request was cancelled.'));
      }
    });

    final responseFuture = http.post(
      Uri.parse('$apiUrl/v1/complete'),
      headers: {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'x-api-key': apiKey,
      },
      body: jsonEncode({
        ...params.toJson(),
        'stream': false,
      }),
    );

    // Forward the response or error to the completer
    responseFuture.then((response) {
      if (!completer.isCompleted) {
        completer.complete(response);
      }
    }).catchError((error) {
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    });

    final response = await completer.future;

    if (response.statusCode != 200) {
      throw SamplingError(
        'Sampling error: ${response.statusCode} ${response.reasonPhrase}',
      );
    }

    return CompletionResponseDto.fromJson(jsonDecode(response.body));
  }

  Future<CompletionResponseDto> completeStream(
    SamplingParametersDto params, {
    void Function(http.StreamedResponse)? onOpen,
    void Function(CompletionResponseDto)? onUpdate,
    CancellationToken? cancellationToken,
  }) async {
    // Create an instance of http.Client.
    final client = http.Client();

    // Create a completer to manage cancellation
    final completer = Completer<CompletionResponseDto>();

    // Handle cancellation
    cancellationToken?.addListener(() {
      if (cancellationToken.isCancelled && !completer.isCompleted) {
        client.close(); // Close the connection when cancelled.
        completer.completeError(AbortError('Request was cancelled.'));
      }
    });

    // Send request
    final request = http.Request('POST', Uri.parse('$apiUrl/v1/complete'))
      ..headers.addAll({
        'Accept': 'text/event-stream',
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      })
      ..body = jsonEncode({
        ...params.toJson(),
        'stream': true,
      });
    final streamedResponse = await client.send(request);

    // Handle server errors
    if (streamedResponse.statusCode != 200) {
      client.close();
      throw SamplingError(
        'Failed to open sampling stream, HTTP status code ${streamedResponse.statusCode}: ${streamedResponse.reasonPhrase}',
      );
    }

    if (onOpen != null) {
      onOpen(streamedResponse);
    }

    // Process the event stream
    final stream = streamedResponse.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter());
    await for (final line in stream) {
      // Check for cancellation
      if (cancellationToken != null && cancellationToken.isCancelled) {
        break;
      }

      var parts = [];

      try {
        parts = line.split('data:');
      } catch (e) {
        print(e);
      }

      String eventData;
      if (parts.length != 2) {
        eventData = line;
      } else {
        eventData = parts[1].trim();
      }

      if (eventData.isNotEmpty) {
        final jsonResponse = jsonDecode(eventData);
        final completion = CompletionResponseDto.fromJson(jsonResponse);

        if (completion.stopReason != null) {
          completer.complete(completion);
          break;
        } else if (onUpdate != null) {
          onUpdate(completion);
        }
      }
    }

    // Close the connection
    client.close();

    return completer.future;
  }
}
