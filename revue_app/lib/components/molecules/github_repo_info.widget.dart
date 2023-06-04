import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github/github.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../helpers/date_utils.dart';

class GitHubRepoInfo extends ConsumerWidget {
  final Repository repository;

  const GitHubRepoInfo(this.repository, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: CachedNetworkImageProvider(
                      repository.owner?.avatarUrl ?? ''),
                ),
                const SizedBox(width: 8),
                Text(
                  '${repository.owner?.login ?? ''} / ',
                  style: textTheme.bodyLarge,
                ),
                Text(
                  repository.name,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Visibility(
              visible: repository.description.isNotEmpty,
              child: Text(
                repository.description,
                softWrap: true,
                style: textTheme.bodySmall,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Chip(
                  label: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${repository.stargazersCount}',
                        style: textTheme.labelSmall,
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.remove_red_eye,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${repository.watchersCount}',
                        style: textTheme.labelSmall,
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        MdiIcons.callSplit,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${repository.forksCount}',
                        style: textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(
                    repository.language,
                    style: textTheme.labelSmall,
                  ),
                ),
              ],
            )
          ]),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Created on: ${friendlyDate(repository.createdAt)}',
                  style: textTheme.labelLarge),
              Text('Last updated ${timeAgo(repository.updatedAt)}',
                  style: textTheme.labelMedium),
            ],
          ),
        ],
      ),
    );
  }
}
