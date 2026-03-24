import 'package:flutter/material.dart';
import 'package:formation_flutter/api/open_food_facts_api.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/service/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<FavoriteItem>> _favorites;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    final authService = context.read<AuthService>();
    setState(() {
      _favorites = _getFavorites(authService);
    });
  }

  Future<List<FavoriteItem>> _getFavorites(AuthService authService) async {
    try {
      final pb = authService.pb;
      final records = await pb.collection('favorites').getFullList(
        filter: 'userId = "${pb.authStore.model.id}"',
      );

      final favorites = <FavoriteItem>[];

      for (final record in records) { //reucp les infos du produit dans l'api
        final barcode = record.getStringValue('barcode');
        try {
          final product = await OpenFoodFactsAPI().getProduct(barcode);
          favorites.add(
            FavoriteItem(
              barcode: barcode,
              productName: product.name,
              brands: product.brands,
              picture: product.picture,
              nutriScore: product.nutriScore,
            ),
          );
        } catch (e) {
          favorites.add( //si l'api crash
            FavoriteItem(
              barcode: barcode,
              productName: 'Produit inconnu',
            ),
          );
        }
      }

      return favorites;
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blue), //flèche en bleu
          onPressed: () => context.pop(),
        ),
        title: const Text('Mes favoris',
        style: TextStyle(
          color: AppColors.blue, //titre en bleu
          fontWeight: FontWeight.bold,
        ),
        ),
      ),
      body: FutureBuilder<List<FavoriteItem>>(
        future: _favorites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) { //si erreur
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Erreur: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadFavorites,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          final favorites = snapshot.data ?? [];

          if (favorites.isEmpty) { //page vide si pas de favoris
            return const Center(
              child: Text('Aucun favori pour le moment'),
            );
          }

          return ListView.builder( //liste des favoris
            padding: const EdgeInsets.all(12),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              return _FavoriteCard(
                favorite: favorite,
                onTap: () {
                  context.push('/product', extra: favorite.barcode);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class FavoriteItem { //données d'un favori
  final String barcode;
  final String? productName;
  final List<String>? brands;
  final String? picture;
  final ProductNutriScore? nutriScore;

  FavoriteItem({
    required this.barcode,
    this.productName,
    this.brands,
    this.picture,
    this.nutriScore,
  });
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({
    required this.favorite,
    required this.onTap,
  });

  final FavoriteItem favorite;
  final VoidCallback onTap;

  Color _getNutriscoreColor(ProductNutriScore? score) { //couleur nutriscore
    return switch (score) {
      ProductNutriScore.A => const Color(0xFF2E7D32),
      ProductNutriScore.B => const Color(0xFF6FA500),
      ProductNutriScore.C => const Color(0xFFFFC107), 
      ProductNutriScore.D => const Color(0xFFFF9800), 
      ProductNutriScore.E => const Color(0xFFC62828), 
      ProductNutriScore.unknown => const Color(0xFF999999),
      null => const Color(0xFF999999),
    };
  }

  String _getNutriscoreLetter(ProductNutriScore? score) { //lettre du nutriscore
    return switch (score) { 
      ProductNutriScore.A => 'A',
      ProductNutriScore.B => 'B',
      ProductNutriScore.C => 'C',
      ProductNutriScore.D => 'D',
      ProductNutriScore.E => 'E',
      ProductNutriScore.unknown => '?',
      null => '?',
    };
  }

  String _getFirstBrand() {
    return favorite.brands?.isNotEmpty ?? false
        ? favorite.brands!.first
        : 'Marque inconnue';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20), //ajout de marge pour le dépassement
      child: InkWell(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none, //pour faire dépasser la photo
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const SizedBox(width: 90), // pour décaler le texte
                    const SizedBox(width: 12),

                    Expanded( //info du produit
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            favorite.productName ?? 'Produit inconnu',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blue,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),

                          Text(
                            _getFirstBrand(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.grey2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _getNutriscoreColor(favorite.nutriScore),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Nutriscore : ${_getNutriscoreLetter(favorite.nutriScore)}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.blue, // Modifié en bleu pour matcher l'historique
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -10, //image dépasse
              left: 13, 
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: favorite.picture != null && favorite.picture!.isNotEmpty
                      ? Image.network(
                          favorite.picture!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.grey1,
                              child: const Icon(Icons.image, color: AppColors.grey2),
                            );
                          },
                        )
                      : Container(
                          color: AppColors.grey1,
                          child: const Icon(Icons.image, color: AppColors.grey2),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}