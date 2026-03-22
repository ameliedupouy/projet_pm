import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:formation_flutter/service/scan_service.dart';
import 'package:formation_flutter/service/auth_service.dart';
import 'package:formation_flutter/api/open_food_facts_api.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:provider/provider.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

//test avec code barre défini avant de mettre la cam 
class _ScannerPageState extends State<ScannerPage> {
  static const String _testBarcode = '3266980239886';
  bool _isProcessing = false;

  Future<void> _processScan() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final product = await OpenFoodFactsAPI().getProduct(_testBarcode);
      final authService = context.read<AuthService>();
      
      await ScanService(authService).saveScan(
        barcode: _testBarcode,
        productName: product.name,
      );

      if (mounted) {
        context.pop();
        context.push('/product', extra: _testBarcode);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
      ),
      body: Center(
        child: _isProcessing
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _processScan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text('SCANNER'),
              ),
      ),
    );
  }
}