import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:formation_flutter/service/scan_service.dart';
import 'package:formation_flutter/service/auth_service.dart';
import 'package:formation_flutter/api/open_food_facts_api.dart';
import 'package:provider/provider.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  late MobileScannerController controller;
  bool _isProcessing = false;
  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _processScan(String barcode) async { //scan détecté
    if (_isProcessing || _hasScanned) return;

    setState(() {
      _isProcessing = true;
      _hasScanned = true;
    });

    try {
      await controller.stop(); //stop le scan

      final product = await OpenFoodFactsAPI().getProduct(barcode); //check le produit dans l'api

      final authService = context.read<AuthService>(); //save dans pb
      await ScanService(authService).saveScan(
        barcode: barcode,
        productName: product.name,
      );

      if (mounted) { //go page produit
        context.pop();
        context.push('/product', extra: barcode);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _hasScanned = false;
        });

        await controller.start();

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
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null && !_hasScanned) {
              _processScan(barcode.rawValue!);
            }
          }
        },
      ),
    );
  }
}