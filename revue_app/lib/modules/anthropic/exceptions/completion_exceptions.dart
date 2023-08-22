class SamplingError extends Error {
  final String message;

  SamplingError(this.message);

  @override
  String toString() => 'SamplingError: $message';
}

class AbortError extends Error {
  final String message;

  AbortError(this.message);

  @override
  String toString() => 'AbortError: $message';
}
