import 'package:formation_flutter/service/auth_service.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:formation_flutter/api/open_food_facts_api.dart';
import 'package:formation_flutter/model/product.dart';

class ScanService {
  final AuthService _authService;

  ScanService(this._authService);

  PocketBase get _pb => _authService.pb;

  Future<void> saveScan({ //save scan dans pb
    required String barcode,
    String? productName,
  }) async {
    if (!_pb.authStore.isValid) {
      throw Exception('Utilisateur non connecté');
    }

    try {
      await _pb.collection('scans').create(body: {
        'userId': _pb.authStore.model.id,
        'barcode': barcode,
        'productName': productName,
        'scannedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Erreur lors de la sauvegarde du scan: $e');
    }
  }

  Future<List<ScanRecord>> getScanHistory() async { //recup historique des scans du user
    if (!_pb.authStore.isValid) {
      throw Exception('Utilisateur non connecté');
    }

    try {
      final records = await _pb.collection('scans').getFullList(
        filter: 'userId = "${_pb.authStore.model.id}"',
        sort: '-scannedAt',
      );

      final scanRecords = <ScanRecord>[];
      
      for (final record in records) {
        final scanRecord = ScanRecord.fromPocketBase(record);
        
        try { //recup les données du produit
          final product = await OpenFoodFactsAPI().getProduct(scanRecord.barcode);
          scanRecords.add(
            ScanRecord(
              id: scanRecord.id,
              barcode: scanRecord.barcode,
              productName: scanRecord.productName,
              scannedAt: scanRecord.scannedAt,
              picture: product.picture,
              nutriScore: product.nutriScore,
              brands: product.brands,
            ),
          );
        } catch (e) {
          scanRecords.add(scanRecord);
        }
      }

      return scanRecords;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'historique: $e');
    }
  }
}

class ScanRecord {
  final String id;
  final String barcode;
  final String? productName;
  final DateTime scannedAt;
  final String? picture;
  final ProductNutriScore? nutriScore;
  final List<String>? brands; 

  ScanRecord({
    required this.id,
    required this.barcode,
    this.productName,
    required this.scannedAt,
    this.picture,
    this.nutriScore,
    this.brands,
  });

  factory ScanRecord.fromPocketBase(RecordModel record) {
    final scannedAtString = record.getStringValue('scannedAt');
    DateTime scannedAt;

    try {
      scannedAt = DateTime.parse(scannedAtString);
    } catch (e) {
      scannedAt = DateTime.now();
    }

    return ScanRecord(
      id: record.id,
      barcode: record.getStringValue('barcode'),
      productName: record.getStringValue('productName'),
      scannedAt: scannedAt,
    );
  }
}