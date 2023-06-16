import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github/github.dart';
import 'package:revue_app/modules/github/dto/github_repository.dto.dart';
import 'package:revue_app/modules/github/github.service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'github_providers.g.dart';

@riverpod
GithubService githubService(GithubServiceRef ref) => GithubService();

final githubRepositorySlugProvider =
    StateProvider<RepositorySlug?>((ref) => null);

@riverpod
Future<GithubRepositoryDto?> githubRepository(
  GithubRepositoryRef ref,
  RepositorySlug slug, {
  String path = 'src',
  String? branch,
  List<String> extensions = const ['ts', 'md', 'json' 'tsx', 'dart'],
}) async {
  final service = ref.watch(githubServiceProvider);

  final repository = await service.getRepository(slug);
  if (repository == null) {
    throw Exception('Repository not found');
  }
  final files = await service.getRepositoryContents(
    slug: slug,
    path: path,
    branch: branch ?? repository.defaultBranch,
    extensions: extensions,
  );
  return GithubRepositoryDto(repository: repository, files: files);
}
