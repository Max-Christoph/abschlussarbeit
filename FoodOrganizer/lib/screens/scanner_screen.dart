import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/food_api_service.dart';
import '../models/user.dart';
import 'product_details_screen.dart';

class ScannerScreen extends StatelessWidget {
  final User user;
  final foodApiService = FoodApiService();

  ScannerScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Food Product'),
      ),
      body: MobileScanner(
        onDetect: (capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? code = barcodes.first.rawValue;
            if (code != null) {
              // Show loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator()),
              );

              // Fetch product details
              final product = await foodApiService.getProduct(code);
              
              // Hide loading indicator
              Navigator.pop(context);

              if (product != null && context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(
                      product: product,
                      user: user,
                    ),
                  ),
                );
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Product not found')),
                  );
                }
              }
            }
          }
        },
      ),
    );
  }
} 