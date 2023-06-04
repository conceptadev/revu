// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: ".env")
abstract class Env {
  @EnviedField(varName: 'GITHUB_TOKEN')
  static const githubToken = _Env.githubToken;
}
