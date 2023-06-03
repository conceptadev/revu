import 'package:dio/dio.dart';

class ClaudeService {
  ClaudeService._();
  static const String _url =
      "https://anthropic-api.herokuapp.com/claude-api/chat";

  static Future<String> sendCodeReviewRequest(String content) async {
    try {
      Response response = await Dio().post(
        _url,
        data: {
          'content': content,
        },
      );

      return response.data;
    } catch (e) {
      throw Exception('Failed to send code review request. $e');
    }
  }
}
