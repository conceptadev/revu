// ignore_for_file: provider_parameters
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revue_app/components/atoms/app_bar.dart';
import 'package:revue_app/modules/github/github_providers.dart';
import 'package:revue_app/screens/chat.screen.dart';

class CodeReviewScreen extends ConsumerWidget {
  const CodeReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slug = ref.watch(githubRepositorySlugProvider);
    final repoData = ref.watch(githubRepositoryProvider(slug!));
    return repoData.when(
      data: (data) {
        if (data == null) {
          return const Text('No data');
        }

        return Scaffold(
          appBar: RepositoryAppBar(data.repository),
          body: ChatScreen(
            repository: data,
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
