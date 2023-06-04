import 'package:dio/dio.dart';

class ClaudeService {
  ClaudeService._();
  static const String _url =
      "https://anthropic-api.herokuapp.com/claude-api/chat";

  // static const String _url =
  //     "https://d2f5-200-170-152-241.ngrok-free.app/claude-api/chat";

  static Future<String> sendCodeReviewRequest(String content,
      [instant = false]) async {
    try {
      String model = instant ? "claude-instant-v1.1-100k" : "claude-v1.3-100k";
      Response response = await Dio().post(
        _url,
        data: {
          'content': content,
          "model": model,
        },
      );

      return response.data;
    } catch (e) {
      throw Exception('Failed to send code review request. $e');
    }
  }
}
