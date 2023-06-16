// // ignore_for_file: provider_parameters
// import 'package:flutter/material.dart';
// import 'package:js/js.dart' as js;
// import 'package:js/js_util.dart' as js_util;
// import 'package:revue_app/screens/chat.screen.dart';

// class CodeReviewWebScreen extends StatefulWidget {
//   const CodeReviewWebScreen({super.key});

//   @override
//   State<CodeReviewWebScreen> createState() => _CodeReviewWebScreenState();
// }

// @js.JSExport()
// class _CodeReviewWebScreenState extends State<CodeReviewWebScreen> {
//   String? codeContext;

//   @override
//   void initState() {
//     super.initState();
//     final export = js_util.createDartExport(this);
//     js_util.setProperty(js_util.globalThis, '_appState', export);
//     js_util.callMethod<void>(js_util.globalThis, '_stateSet', []);
//   }

//   @js.JSExport()
//   sendContext(String context) {
//     setState(() {
//       codeContext = context;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: codeContext != null
//           ? ChatScreen(
//               codeContext: codeContext!,
//             )
//           : const Center(
//               child: Text('Loading...'),
//             ),
//     );
//   }
// }
