import 'package:flutter/material.dart';
import 'package:formation_flutter/model/recall.dart';

class RecallDetailsPage extends StatelessWidget {
  const RecallDetailsPage({super.key, required this.recall});

  final Recall recall;

  @override
  Widget build(BuildContext context) {
    final sections = [
      ('Numéro de fiche', recall.numeroFiche),
      ('Produit', recall.libelle),
      ('Marque', recall.marqueProduit),
      ('Motif du rappel', recall.motifRappel),
      ('Date de publication', recall.datePublication.toString()),
      ('Date de fin du rappel', recall.dateFinRappel.toString()),
      ];

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Rappel produit - Détails')),
        body: ListView.separated(
          itemCount: sections.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final (title, value) = sections[index];
            return ListTile(
              title: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                ),
              subtitle: Text(
                value ?? '',
                textAlign: TextAlign.center,
                ),
            );
          },
        ),
      );
  }
}