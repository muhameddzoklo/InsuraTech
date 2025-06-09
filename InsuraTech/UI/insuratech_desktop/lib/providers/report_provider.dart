import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/report.dart';
import 'auth_provider.dart';

class ReportProvider with ChangeNotifier {
  static String? baseUrl = const String.fromEnvironment(
    "baseUrl",
    defaultValue: "http://localhost:5200/api/",
  );

  Report? _report;
  bool _isLoading = false;
  String? _error;

  Report? get report => _report;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchReport() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final url = Uri.parse("${baseUrl}Reports");
      final headers = _createHeaders();

      final response = await http.get(url, headers: headers);

      if (response.statusCode < 299) {
        final data = jsonDecode(response.body);
        _report = Report.fromJson(data);
      } else if (response.statusCode == 401) {
        throw UserFriendlyException("Unauthorized");
      } else {
        throw Exception("Error: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      _error = e.toString();
      _report = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, String> _createHeaders() {
    String username = AuthProvider.username ?? "";
    String password = AuthProvider.password ?? "";
    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";
    return {"Content-Type": "application/json", "Authorization": basicAuth};
  }
}

class UserFriendlyException implements Exception {
  final String message;
  UserFriendlyException(this.message);
  @override
  String toString() => message;
}
