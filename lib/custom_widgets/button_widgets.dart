import 'package:flutter/material.dart';

class RetryButton extends StatelessWidget {
  const RetryButton({required this.onRetryPressed, super.key});

  final void Function() onRetryPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onRetryPressed,
      icon: const Icon(Icons.refresh),
      color: Theme.of(context).primaryColor,
      iconSize: 38.0,
      splashColor: Theme.of(context).splashColor,
      highlightColor: Theme.of(context).highlightColor,
    );
  }
}

class ErrorButton extends StatelessWidget {
  const ErrorButton({
    required this.errorMessage,
    required this.onRetryPressed,
    super.key,
  });

  final String errorMessage;
  final void Function() onRetryPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RetryButton(onRetryPressed: onRetryPressed),
          const SizedBox(height: 8.0),
          Text(
            errorMessage,
            style: const TextStyle(
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
