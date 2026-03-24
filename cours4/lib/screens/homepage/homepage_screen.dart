import 'package:flutter/material.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:formation_flutter/screens/homepage/homepage_empty.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:formation_flutter/service/auth_service.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/service/scan_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<ScanRecord>> _scanHistory;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    final authService = context.read<AuthService>();
    setState(() {
      _scanHistory = ScanService(authService).getScanHistory();
    });
  }

  void _onScanButtonPressed(BuildContext context) {
    context.push('/scanner').then((_) {
      _loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.my_scans_screen_title,
          style: const TextStyle(
            color: AppColors.blue, //texte en bleu foncé
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.star, color: AppColors.blue),
            tooltip: 'Favoris',
            onPressed: () {
              context.push('/favorites');
            },
          ),
          IconButton(
            icon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 8.0),
              child: Icon(AppIcons.barcode, color: AppColors.blue),
            ),
            tooltip: 'Scanner',
            onPressed: () {
              context.push('/scanner').then((_) {
                _loadHistory();
              });
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: AppColors.blue,
            ), //icône plus ressemblante mais c'est pas encore
            tooltip: 'Déconnexion',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    'Déconnexion',
                    style: TextStyle(
                      //modification de la fenetre pop up pour être plus dans le thème de l'appli
                      color: AppColors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Text(
                    'Êtes-vous sûr de vouloir vous déconnecter ?',
                    style: TextStyle(color: AppColors.grey3),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        foregroundColor: AppColors.blue,
                        elevation: 0,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () async {
                        await context.read<AuthService>().logout();
                        if (context.mounted) {
                          context.go('/login');
                        }
                      },
                      child: const Text(
                        'Se déconnecter',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ScanRecord>>(
        future: _scanHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
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
                    onPressed: _loadHistory,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          final scans = snapshot.data ?? [];

          if (scans.isEmpty) {
            //page vide si pas de scan
            return HomePageEmpty(
              onScan: () {
                _onScanButtonPressed(context);
              },
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: scans.length,
            itemBuilder: (context, index) {
              final scan = scans[index];
              return _ScanCard(
                scan: scan,
                onTap: () {
                  context.push('/product', extra: scan.barcode);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _ScanCard extends StatelessWidget {
  const _ScanCard({required this.scan, required this.onTap});

  final ScanRecord scan;
  final VoidCallback onTap;

  Color _getNutriscoreColor(ProductNutriScore? score) {
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

  String _getNutriscoreLetter(ProductNutriScore? score) {
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
    return scan.brands?.isNotEmpty ?? false
        ? scan.brands!.first
        : 'Marque inconnue';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
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

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scan.productName ?? 'Produit inconnu',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blue,
                            ),
                            maxLines: 1,
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
                                  color: _getNutriscoreColor(scan.nutriScore),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Nutriscore : ${_getNutriscoreLetter(scan.nutriScore)}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.blue,
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
                  child: scan.picture != null && scan.picture!.isNotEmpty
                      ? Image.network(scan.picture!, fit: BoxFit.cover)
                      : Container(
                          color: AppColors.grey1,
                          child: const Icon(
                            Icons.image,
                            color: AppColors.grey2,
                          ),
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
