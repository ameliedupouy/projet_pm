# Projet Programmation Mobile - Formation Flutter

## Description

Ce projet est une application mobile de scan de produits alimentaires inspirée de Yuka.  
Elle permet de scanner des produits, consulter leurs informations, gérer des favoris et être alerté en cas de rappel sanitaire.

L'application est développée avec Flutter pour le front-end et PocketBase pour le back-end.



## Fonctionnalités

### Front-end (Flutter)

- Détails produits : Récupération des données en temps réel via l'API Open Food Facts
- Authentification : Gestion multi-utilisateur (Email/Mot de passe)
- Historique : Sauvegarde automatique de chaque produit consulté
- Favoris : Possibilité d'ajouter un produit en favori
- Rappels produits : Affichage d'alertes en cas de rappel sanitaire

### Back-end (PocketBase)

- Base de données : Stockage des utilisateurs, scans, favoris et rappels produits
- Extensions (Hooks) : Synchronisation avec les données du Ministère de l'Économie pour les alertes sanitaires



## Stack technique

- Flutter (Dart)
- PocketBase
- Open Food Facts API



## Installation et lancement

### 1. Prérequis

- Flutter SDK (dernière version stable)
- Binaire PocketBase (à placer à la racine du dossier `cours4/`)

### 2. Installation des dépendances

```bash
cd cours4
flutter pub get
```

### 3. Lancement du backend (PocketBase)

```bash
cd cours4
./pocketbase serve
```


### 4. Lancement du front-end

#### Sur simulateur / navigateur

```bash
flutter run
```

#### Sur téléphone physique

1. Brancher le téléphone et activer le débogage USB  
2. Récupérer l'adresse IP de votre machine  
3. Modifier l'URL du serveur dans :
   - `lib/service/auth_service.dart` (ligne 5)
   - `lib/service/pocketbase_service.dart` (ligne 12)

4. Lancer PocketBase avec accès réseau :

```bash
./pocketbase serve --http 0.0.0.0:8090
```

5. Lancer l'application :

```bash
flutter run
```



## Architecture de la base de données

| Collection           | Rôle |
|---------------------|------|
| users               | Gestion des utilisateurs |
| scans               | Historique des scans |
| favorites           | Produits favoris |
| rappels_produits    | Cache des alertes sanitaires |



## Structure du projet

```
lib/
 ├── api/       # Appels API Open Food Facts
 ├── l10n/      # Internationalisation
 ├── model/     # Modèles de données
 ├── res/       # Ressources (couleurs, icônes)
 ├── screens/   # Interfaces utilisateur
 └── service/   # Logique métier et accès backend
```

## Équipe

Projet réalisé dans le cadre du cours de programmation mobile par Amélie Dupouy & Inès Haller - CReATE, ECE Paris
