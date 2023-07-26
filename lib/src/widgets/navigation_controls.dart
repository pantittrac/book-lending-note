import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NavigationControls extends StatelessWidget {
  const NavigationControls({super.key, required this.controller});

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            if (await controller.canGoBack()) controller.goBack();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        IconButton(
          onPressed: () async {
            if (await controller.canGoForward()) controller.goForward();
          },
          icon: const Icon(Icons.arrow_forward),
        ),
        IconButton(
          onPressed: () {
            controller.reload();
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}
