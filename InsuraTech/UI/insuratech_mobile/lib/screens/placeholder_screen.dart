import 'package:flutter/material.dart';
import 'package:insuratech_mobile/layouts/master_screen.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      appBarTitle: 'Placeholder screen',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            Text("Ovdje ide sadržaj screena"),
            // dodaj svoj layout...
          ],
        ),
      ),
    );
  }
}
