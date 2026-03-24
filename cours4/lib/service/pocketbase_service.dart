import 'package:pocketbase/pocketbase.dart';

class PocketBaseService {
  static final PocketBaseService _instance = PocketBaseService._internal();
  late final PocketBase client;

  factory PocketBaseService() {
    return _instance;
  }

  PocketBaseService._internal() {
    //client = PocketBase('http://172.19.236.238:8090'); //serveur local
    client = PocketBase('http://localhost:8090');
  }

  Future<List<Map<String, dynamic>>> getRappels() async {
    //récup les rappels produits
    try {
      final result = await client.collection('rappels_produits').getFullList();
      return result.map((record) => record.data).toList();
    } catch (e) {
      print('Erreur PocketBase: $e'); //test
      return [];
    }
  }
}
