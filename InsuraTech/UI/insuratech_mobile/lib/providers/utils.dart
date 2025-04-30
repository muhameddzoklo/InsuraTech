import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

String formatNumber(dynamic) {
  var f = NumberFormat('###,00');
  if (dynamic == null) {
    return "";
  }
  return f.format(dynamic);
}

String formatDate(DateTime date) {
  return DateFormat('dd.MM.yyyy.').format(date);
}

String formatDateString(String? dateString) {
  if (dateString == null || dateString.isEmpty) return '-';
  try {
    final date = DateTime.parse(dateString);
    return DateFormat('dd.MM.yyyy.').format(date);
  } catch (e) {
    return '-';
  }
}

Image imageFromString(String input) {
  return Image.memory(base64Decode(input));
}

Future<bool> showCustomConfirmDialog(
  BuildContext context, {
  required String title,
  required String text,
  String confirmBtnText = 'Yes',
  String cancelBtnText = 'No',
  Color confirmBtnColor = Colors.green,
  Color cancelBorderColor = Colors.grey,
}) async {
  if (!context.mounted) return false;
  bool confirmed = false;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.help_outline, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      confirmed = false;
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: cancelBorderColor, width: 1.5),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(cancelBtnText),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      confirmed = true;
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmBtnColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: Text(confirmBtnText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  return confirmed;
}




Future<void> showSuccessAlert(BuildContext context, String message) async {
  if (!context.mounted) return;
  await QuickAlert.show(
    context: context,
    type: QuickAlertType.success,
    title: "Success",
    text: message,
  );
}

Future<void> showErrorAlert(BuildContext context, String message) async {
  if (!context.mounted) return;
  await QuickAlert.show(
    context: context,
    type: QuickAlertType.error,
    title: "Error",
    text: message,
  );
}
