import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:revue_app/components/molecules/github_repo_info.widget.dart';

class RepositoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Repository repository;
  const RepositoryAppBar(this.repository, {super.key});

  @override
  Size get preferredSize {
    return const Size.fromHeight(120.0);
  }

  @override
  Widget build(BuildContext context) {
    return GitHubRepoInfo(repository);
  }
}
