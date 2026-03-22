import 'package:formation_flutter/service/auth_service.dart';
import 'package:pocketbase/pocketbase.dart';

class FavoriteService {
  final AuthService _authService;

  FavoriteService(this._authService);

  PocketBase get _pb => _authService.pb;

  Future<void> addFavorite(String barcode) async { //ajouter produit aux fav
    if (!_pb.authStore.isValid) {
      throw Exception('Utilisateur non connecté');
    }

    try {
      await _pb.collection('favorites').create(body: {
        'userId': _pb.authStore.model.id,
        'barcode': barcode,
      });
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout aux favoris: $e');
    }
  }

  Future<void> removeFavorite(String barcode) async { //retirer
    if (!_pb.authStore.isValid) {
      throw Exception('Utilisateur non connecté');
    }

    try {
      final records = await _pb.collection('favorites').getFullList(
        filter: 'userId = "${_pb.authStore.model.id}" && barcode = "$barcode"',
      );

      for (final record in records) {
        await _pb.collection('favorites').delete(record.id);
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression des favoris: $e');
    }
  }

  Future<bool> isFavorite(String barcode) async { //verif si fav ou pas
    if (!_pb.authStore.isValid) {
      throw Exception('Utilisateur non connecté');
    }

    try {
      final records = await _pb.collection('favorites').getFullList(
        filter: 'userId = "${_pb.authStore.model.id}" && barcode = "$barcode"',
      );

      return records.isNotEmpty;
    } catch (e) {
      throw Exception('Erreur lors de la vérification des favoris: $e');
    }
  }
}