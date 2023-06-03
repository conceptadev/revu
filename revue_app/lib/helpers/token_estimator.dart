// ROUGH token estimator
class TokenEstimator {
  static const int charToken = 4;
  static const double wordToken = 0.75;

  TokenEstimator._();

  static int _estimateTokensByWord(String text) {
    double wordCount = text.split(' ').length.toDouble();
    int tokenCount = (wordCount / wordToken).round();
    return tokenCount;
  }

  static int _estimateTokensByChar(String text) {
    int charCount = text.length;
    int tokenCount = (charCount / charToken).round();
    return tokenCount;
  }

  static int estimateAverageTokens(String text) {
    int tokens1 = _estimateTokensByChar(text);
    int tokens2 = _estimateTokensByWord(text);

    return ((tokens1 + tokens2) ~/ 2);
  }
}
