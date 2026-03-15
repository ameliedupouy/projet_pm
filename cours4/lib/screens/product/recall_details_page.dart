import 'package:flutter/material.dart';
import 'package:formation_flutter/model/recall.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:formation_flutter/res/app_icons.dart';

class RecallDetailsPage extends StatelessWidget {
  const RecallDetailsPage({
    super.key, 
    required this.recall,
    this.product,
  });

  final Recall recall;
  final Product? product; //pour afficher la photo du produit

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _RecallAppBar(recall: recall),
          
          SliverList(
            delegate: SliverChildListDelegate([
              if (product?.picture != null && product!.picture!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 32.0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      product!.picture!,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                ),

              if (recall.dateDebut != null || recall.dateFin != null)
                _SectionCard(
                  title: 'Dates de commercialisation',
                  content: _formatDates(recall.dateDebut, recall.dateFin),
                ),

              if (recall.distributeurs != null && recall.distributeurs!.isNotEmpty)
                _SectionCard(
                  title: 'Distributeurs',
                  content: recall.distributeurs!,
                ),

              if (recall.zoneGeographique != null && recall.zoneGeographique!.isNotEmpty)
                _SectionCard(
                  title: 'Zone géographique',
                  content: recall.zoneGeographique!,
                ),

              if (recall.motifRappel != null && recall.motifRappel!.isNotEmpty)
                _SectionCard(
                  title: 'Motif du rappel',
                  content: recall.motifRappel!,
                ),

              if (recall.risquesEncorus != null && recall.risquesEncorus!.isNotEmpty)
                _SectionCard(
                  title: 'Risques encourus',
                  content: recall.risquesEncorus!,
                ),

              if (recall.preconisationsSanitaires != null && 
                  recall.preconisationsSanitaires!.isNotEmpty)
                _SectionCard(
                  title: 'Informations complémentaires',
                  content: recall.preconisationsSanitaires!,
                ),

              if (recall.conduiteATenir != null && recall.conduiteATenir!.isNotEmpty)
                _SectionCard(
                  title: 'Conduite à tenir',
                  content: recall.conduiteATenir!,
                ),

              const SizedBox(height: 32.0),
            ]),
          ),
        ],
      ),
    );
  }

  String _formatDates(String? debut, String? fin) { //date au format fr
    if (debut == null || fin == null) return '';
    
    try {
      final dateDebut = DateTime.parse(debut);
      final dateFin = DateTime.parse(fin);
      
      final dDebut = '${dateDebut.day}/${dateDebut.month}/${dateDebut.year}';
      final dFin = '${dateFin.day}/${dateFin.month}/${dateFin.year}';
      
      return 'Du $dDebut au $dFin';
    } catch (e) {
      return 'Du $debut au $fin';
    }
  }
}

class _RecallAppBar extends StatelessWidget {
  const _RecallAppBar({required this.recall});

  final Recall recall;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      title: const Text(
        'Rappel produit',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A237E),
        ),
      ),
      centerTitle: false,
      actions: [
      if (recall.urlPdf != null && recall.urlPdf!.isNotEmpty) //verif que le pdf existe
        IconButton(
          icon: Transform.scale(
            scaleX : -1, //reverse la flèche
            child: const Icon(AppIcons.share, color: Color(0xFF1A237E)),
          ),
            onPressed: () => _openPdf(recall.urlPdf!), //fiche pdf
          tooltip: 'Ouvrir la fiche PDF',
        ),
        
      ],
    );
  }

  //ouvre le pdf
  void _openPdf(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF616161),
              height: 1.5,
            ),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
        ),
      ],
    );
  }
}