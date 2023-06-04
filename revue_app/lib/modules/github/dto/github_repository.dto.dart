import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:github/github.dart';

part 'github_repository.dto.freezed.dart';

@freezed
class GithubRepositoryDto with _$GithubRepositoryDto {
  const factory GithubRepositoryDto({
    required Repository repository,
    required List<GitHubFile> files,
  }) = _GithubRepositoryDto;
}
