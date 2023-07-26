import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  final VoidCallback func;
  
  const ErrorDialog({super.key, required this.message, required this.func});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.error_outline_rounded, size: 60,),
      iconColor: Colors.red,
      content: Text('Error: $message'),
      actions: [ElevatedButton(onPressed: func, child: const Text('OK'))],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
