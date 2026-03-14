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
  
  //ajout pour la page recall
  final String? dateDebut;
  final String? dateFin;
  final String? distributeurs;
  final String? zoneGeographique;
  final String? risquesEncorus;
  final String? preconisationsSanitaires;
  final String? conduiteATenir;
  final String? urlPdf;

  const Recall({
    required this.id,
    this.numeroFiche,
    this.gtin,
    this.libelle,
    this.marqueProduit,
    this.motifRappel,
    this.datePublication,
    this.dateFinRappel,
    this.dateDebut,
    this.dateFin,
    this.distributeurs,
    this.zoneGeographique,
    this.risquesEncorus,
    this.preconisationsSanitaires,
    this.conduiteATenir,
    this.urlPdf,
  });

  factory Recall.fromRecord(RecordModel record) {
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
      
      //ajout toujours pour la page recall
      dateDebut: json['date_debut_commercialisation'] as String?,
      dateFin: json['date_fin_commercialisation'] as String?,
      distributeurs: json['distributeurs'] as String?,
      zoneGeographique: json['zone_geographique_de_vente'] as String?,
      risquesEncorus: json['risques_encourus'] as String?,
      preconisationsSanitaires: json['preconisations_sanitaires'] as String?,
      conduiteATenir: json['conduites_a_tenir_par_le_consommateur'] as String?,
      urlPdf: json['lien_vers_affichette_pdf'] as String?,
    );
  }
}