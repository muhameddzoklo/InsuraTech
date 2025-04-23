import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:insuratech_mobile/layouts/master_screen.dart';
import 'package:insuratech_mobile/models/insurance_package.dart';

class InsurancePackageDetailsScreen extends StatelessWidget {
  final InsurancePackage package;

  const InsurancePackageDetailsScreen({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    if (package.picture != null && package.picture!.isNotEmpty) {
      imageBytes = base64Decode(package.picture!);
    }

    return MasterScreen(
      appBarTitle: "Package Details",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:
                  imageBytes != null
                      ? Image.memory(
                        imageBytes,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 220,
                      )
                      : Image.asset(
                        "assets/images/placeholder.png",
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: 220,
                      ),
            ),
            const SizedBox(height: 20),
            Text(
              package.name ?? 'Unnamed Package',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              package.description ?? 'No description provided.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "Price: \$${package.price?.toStringAsFixed(2) ?? 'N/A'}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
