import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

class AuthService extends ChangeNotifier {
  final PocketBase pb = PocketBase('http://172.19.236.238:8090'); //ip à changer pour chaque réseau wifi
  
  bool get isAuthenticated => pb.authStore.isValid; //verif si l'utilisateur est connecté
  String? get userEmail => pb.authStore.record?.getStringValue('email');
  String? get userId => pb.authStore.record?.id;

  Future<bool> login(String email, String password) async {
    try {
      await pb.collection('users').authWithPassword(email, password);
      notifyListeners();
      return true;
    } catch (e) {
      print('Erreur de connexion: $e');
      rethrow;
    }
  }

  Future<bool> signup(String email, String password, String name) async {
    try {
      await pb.collection('users').create(body: {
        'email': email,
        'password': password,
        'passwordConfirm': password,
        'name': name,
      });
      
      await login(email, password); //se connecte direct après avoir fait l'inscription
      notifyListeners();
      return true;
    } catch (e) {
      print('Erreur d\'inscription: $e');
      rethrow;
    }
  }

  Future<void> logout() async { //deconnexion
    pb.authStore.clear();
    notifyListeners();
  }

  Future<bool> checkAuthStatus() async {
    try {
      if (pb.authStore.isValid) {
        await pb.collection('users').getOne(pb.authStore.record?.id ?? '');
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      pb.authStore.clear();
      notifyListeners();
      return false;
    }
  }
}