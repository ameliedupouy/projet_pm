import 'package:flutter/material.dart';
import 'package:formation_flutter/model/recall.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:formation_flutter/res/app_colors.dart';

class RecallDetailsPage extends StatelessWidget {
  const RecallDetailsPage({
    super.key,
    required this.recall,
    this.product,
  });

  final Recall recall;
  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _RecallAppBar(recall: recall),
          SliverToBoxAdapter(
            child: Column(
              children: [
                if (product?.picture != null && product!.picture!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                    child: Center(
                      child: Image.network(
                        product!.picture!,
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),

                if (_hasData(recall.dateDebut) || _hasData(recall.dateFin))
                  _SectionCard(
                    title: 'Dates de commercialisation',
                    content: _formatDates(recall.dateDebut, recall.dateFin),
                  ),

                if (_hasData(recall.distributeurs))
                  _SectionCard(
                    title: 'Distributeurs',
                    content: recall.distributeurs!,
                  ),

                if (_hasData(recall.zoneGeographique))
                  _SectionCard(
                    title: 'Zone géographique',
                    content: recall.zoneGeographique!,
                  ),

                if (_hasData(recall.motifRappel))
                  _SectionCard(
                    title: 'Motif du rappel',
                    content: recall.motifRappel!,
                  ),

                if (_hasData(recall.risquesEncorus))
                  _SectionCard(
                    title: 'Risques encourus',
                    content: recall.risquesEncorus!,
                  ),

                if (_hasData(recall.preconisationsSanitaires))
                  _SectionCard(
                    title: 'Informations complémentaires',
                    content: recall.preconisationsSanitaires!,
                  ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _hasData(String? text) => text != null && text.trim().isNotEmpty && text != "null";

  String _formatDates(String? debut, String? fin) {
    if (debut == null && fin == null) return '';
    try {
      final d = debut != null ? _parseDate(debut) : '?';
      final f = fin != null ? _parseDate(fin) : '?';
      return 'Du $d au $f';
    } catch (e) {
      return 'Période de commercialisation';
    }
  }

  String _parseDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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
      foregroundColor: AppColors.blue,
      title: const Text(
        'Rappel produit',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      ),
      actions: [
        if (recall.urlPdf != null && recall.urlPdf!.isNotEmpty)
          IconButton(
            icon: const Icon(AppIcons.share),
            onPressed: () => _openPdf(recall.urlPdf!),
          ),
      ],
    );
  }

  void _openPdf(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.content});
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: const Color(0xFFF8F9FA),
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.blue,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF757575),
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}