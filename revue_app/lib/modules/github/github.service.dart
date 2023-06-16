import 'package:equatable/equatable.dart';
import 'package:github/github.dart';
import 'package:revue_app/env/env.dart';

class RepositoryOptions extends Equatable {
  final String owner;
  final String name;

  const RepositoryOptions({
    required this.owner,
    required this.name,
  });

  RepositorySlug get slug => RepositorySlug(owner, name);

  @override
  List<Object?> get props => [
        owner,
        name,
      ];
}

// auth: Authentication.withToken(Env.githubToken)
final _github = GitHub(auth: Authentication.withToken(Env.githubToken));

class GithubService {
  GithubService();

  // Get github repository info
  Future<Repository?> getRepository(RepositorySlug slug) async {
    return await _github.repositories.getRepository(slug);
  }

  // https://raw.githubusercontent.com/conceptadev/rockets

  Future<List<GitHubFile>> getRepositoryContents({
    required RepositorySlug slug,
    required String branch,
    required String path,
    List<String> extensions = const [],
  }) async {
    final contents = await _github.repositories.getContents(
      slug,
      path,
      ref: branch,
    );

    final matchedFiles = <GitHubFile>[];

    void addFile(GitHubFile file) {
      if (extensions.isEmpty) {
        matchedFiles.add(file);
      }

      final extension = file.name?.split('.').last;
      if (extension != null && extensions.contains(extension)) {
        matchedFiles.add(file);
      }
    }

    if (contents.isFile) {
      addFile(contents.file!);
    } else if (contents.isDirectory) {
      final files = contents.tree ?? [];
      // return getRepositoryContents(slug: slug, branch: branch, path:contents.);
      for (var file in files) {
        final path = file.path;
        if (path != null) {
          final nestedFiles = await getRepositoryContents(
            slug: slug,
            branch: branch,
            path: path,
            extensions: extensions,
          );

          matchedFiles.addAll(nestedFiles);
        }
      }
    }

    return matchedFiles;
  }

  dispose() {
    _github.dispose();
  }
}


// https://github.com/ChristopherMarques/concepta-challenge
