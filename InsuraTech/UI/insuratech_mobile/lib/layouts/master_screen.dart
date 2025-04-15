import 'package:flutter/material.dart';

class MasterScreen extends StatelessWidget {
  final Widget child;
  final String appBarTitle;
  final bool showBackButton;

  const MasterScreen({
    super.key,
    required this.child,
    required this.appBarTitle,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4E0C8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE4E0C8),
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null,
        title: Text(
          appBarTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: child,
    );
  }
}
