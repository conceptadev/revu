// ignore_for_file: provider_parameters
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:github/github.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:revue_app/helpers/input_decoration.dart';
import 'package:revue_app/modules/github/github_providers.dart';

class CodeReviewStartScreen extends HookConsumerWidget {
  CodeReviewStartScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slugController = useTextEditingController(
      text: 'ChristopherMarques/concepta-challenge',
    );
    final branchController = useTextEditingController(text: 'main');
    final extensionsController = useTextEditingController(text: 'ts, tsx');
    final directoryController = useTextEditingController(text: 'src');

    final errorMessage = useState<String?>(null);
    final submitting = useState(false);

    Future<void> checkRepoExists(RepositorySlug slug) async {
      final github = ref.read(githubServiceProvider);

      try {
        final repo = await github.getRepository(slug);
        if (repo != null) {
          ref.read(githubRepositorySlugProvider.notifier).state = slug;
        }
      } catch (e) {
        errorMessage.value = 'Repository does not exist';
      }
    }

    void handleSubmit() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      try {
        submitting.value = true;
        final parts = slugController.text.split("/");
        final extensions = extensionsController.text.split(",");
        // trim whitespace
        for (var element in extensions) {
          element.trim();
        }

        final slug = RepositorySlug(
          parts[0],
          parts[1],
        );
        await checkRepoExists(slug);
      } on Exception catch (e) {
        errorMessage.value = e.toString();
      } finally {
        submitting.value = false;
      }
    }

    String? validateSlug(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a repository slug';
      }
      final slug = value.split("/");
      if (slug.length != 2) {
        return 'Please enter a valid repository slug';
      }
      return null;
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Icon(
                MdiIcons.github,
                size: 80,
              ),
              const SizedBox(height: 30),
              const Text(
                'Choose the repository to start review',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: slugController,
                validator: validateSlug,
                decoration: customInputDecoration(
                  context,
                  hintText: 'owner/repo',
                  labelText: "Github Repository",
                ),
              ),
              // const SizedBox(height: 10),
              // TextFormField(
              //   controller: branchController,
              //   decoration: customInputDecoration(
              //     context,
              //     labelText: 'Branch',
              //     hintText: 'e.g. main',
              //   ),
              //   validator: (value) => value == null || value.isEmpty
              //       ? 'Please enter a branch'
              //       : null,
              // ),
              // const SizedBox(height: 10),
              // TextFormField(
              //   controller: extensionsController,
              //   decoration: customInputDecoration(
              //     context,
              //     labelText: 'File extensions',
              //     hintText: 'e.g. .dart,.py,.js',
              //   ),
              //   validator: (value) => value == null || value.isEmpty
              //       ? 'Please enter at least one extension'
              //       : null,
              // ),
              // const SizedBox(height: 10),
              // TextFormField(
              //   controller: directoryController,
              //   decoration: customInputDecoration(
              //     context,
              //     labelText: 'Directory',
              //     hintText: 'e.g. src',
              //   ),
              // ),
              // const SizedBox(height: 10),
              Text(
                errorMessage.value ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16.0, color: Colors.red),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  handleSubmit();
                },
                child: submitting.value
                    ? const CupertinoActivityIndicator()
                    : const Text('Start'),
              ),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }
}
