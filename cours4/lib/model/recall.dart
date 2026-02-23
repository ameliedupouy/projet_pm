import 'package:pocketbase/pocketbase.dart';
class Recall {
  final String id;
  final String? numeroFiche;
  final String? gtin;
  final String? libelle;
  final String? marqueProduit;
  final String? motifRappel;
  final String? datePublication;
  final String? dateFinRappel;
  final bool? actif;

  const Recall({
    required this.id,
    this.numeroFiche,
    this.gtin,
    this.libelle,
    this.marqueProduit,
    this.motifRappel,
    this.datePublication,
    this.dateFinRappel,
    this.actif,
  });

  factory Recall.fromRecord(RecordModel record){
    final Map<String, dynamic> json = record.data;
    return Recall(
      id: record.id,
      numeroFiche: json['numero_fiche'] as String?,
      gtin: json['gtin'] as String?,
      libelle: json['libelle'] as String?,
      marqueProduit: json['marque_produit'] as String?,
      motifRappel: json['motif_rappel'] as String?,
      datePublication: json['date_publication'] as String?,
      dateFinRappel: json['date_de_fin_de_la_procedure_de_rappel'] as String?,
      actif: json['actif'] as bool?,
    );
  }

}
