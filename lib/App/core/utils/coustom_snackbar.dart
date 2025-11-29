import 'package:flutter/material.dart';

// --- Define the CustomSnackbar class ---

class CustomSnackbar {
  // Base utility method to show the snack bar
  static void _show(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    // Ensure any currently showing snackbar is hidden before showing a new one
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 3), // Default duration
        behavior: SnackBarBehavior.floating, // Helps on large screens
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // --- Public methods for different statuses ---

  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message,
      Colors.green.shade600,
      Icons.check_circle_outline,
    );
  }

  static void showFailure(BuildContext context, String message) {
    _show(
      context,
      message,
      Colors.red.shade700,
      Icons.error_outline,
    );
  }

  static void showNetworkError(BuildContext context) {
    _show(
      context,
      'Network error. Please check your internet connection and try again.',
      Colors.blueGrey.shade700,
      Icons.wifi_off,
    );
  }
}