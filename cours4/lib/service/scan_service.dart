import 'package:formation_flutter/service/auth_service.dart';
import 'package:pocketbase/pocketbase.dart';

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
}