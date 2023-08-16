import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:revue_app/modules/github/github_providers.dart';
import 'package:revue_app/screens/code_review.dart';
import 'package:revue_app/screens/code_review_start.screen.dart';
import 'package:revue_app/screens/code_review_web_screen.dart';

GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class AppShell extends HookConsumerWidget {
  const AppShell({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repositorySlug = ref.watch(githubRepositorySlugProvider);

    final hasRepositoryOptions = repositorySlug != null;

    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: const Scaffold(
        body: CodeReviewWebScreen(),
      ),
    );
  

    // return ScaffoldMessenger(
    //   key: scaffoldMessengerKey,
    //   child: Scaffold(
    //     body: hasRepositoryOptions
    //         ? const CodeReviewScreen()
    //         : CodeReviewStartScreen(),
    //   ),
    // );

    // child: AdaptiveScaffold(
    //   smallBreakpoint: const WidthPlatformBreakpoint(end: 700),
    //   mediumBreakpoint: const WidthPlatformBreakpoint(begin: 700, end: 1000),
    //   largeBreakpoint: const WidthPlatformBreakpoint(begin: 1000),
    //   useDrawer: false,
    //   selectedIndex: selectedTab.value,
    //   onSelectedIndexChange: (int index) {
    //     selectedTab.value = index;
    //   },
    //   destinations: const <NavigationDestination>[
    //     NavigationDestination(
    //       icon: Icon(Icons.inbox_outlined),
    //       selectedIcon: Icon(Icons.inbox),
    //       label: 'Code Review',
    //     ),
    //     NavigationDestination(
    //       icon: Icon(Icons.article_outlined),
    //       selectedIcon: Icon(Icons.article),
    //       label: 'Articles',
    //     ),
    //     NavigationDestination(
    //       icon: Icon(Icons.chat_outlined),
    //       selectedIcon: Icon(Icons.chat),
    //       label: 'Chat',
    //     ),
    //     NavigationDestination(
    //       icon: Icon(Icons.video_call_outlined),
    //       selectedIcon: Icon(Icons.video_call),
    //       label: 'Video',
    //     ),
    //     NavigationDestination(
    //       icon: Icon(Icons.home_outlined),
    //       selectedIcon: Icon(Icons.home),
    //       label: 'Inbox',
    //     ),
    //   ],
    //   body: (_) => hasRepositoryOptions
    //       ? const CodeReviewScreen()
    //       : CodeReviewStartScreen(),
    // ),
  }
}
