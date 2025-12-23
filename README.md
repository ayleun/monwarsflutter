# CORAN Warsh - Application Flutter

Application de lecture du Coran (récitation Warsh) développée avec Flutter.

## Fonctionnalités

### ✅ Implémentées
- 📖 **Lecture du Coran** : Naviguez entre les 30 Juzz avec interface moderne
- 🕐 **Heures de Prière** : Récupération automatique des heures de prière depuis une API
- 🧭 **Direction Qibla** : Boussole pour se diriger vers la Mecque
- ⭐ **Système de Favoris** : Sauvegardez vos versets favoris
- 📍 **Suivi de Lecture** : Reprenez votre lecture là où vous l'avez laissée
- 🎨 **Interface Moderne** : Design Material avec thème orange

### 🚧 En Développement
- Auto-scroll lors de la lecture
- Gestion complète des images des pages du Coran
- Intégration des sons de récitation

## Structure du Projet

```
lib/
├── main.dart                    # Point d'entrée de l'application
├── models/                      # Modèles de données
│   ├── juzz_item.dart          # Modèle pour un Juzz
│   └── page_item.dart          # Modèle pour une page
├── services/                    # Services et logique métier
│   ├── juzz_data_service.dart  # Gestion des données Juzz
│   ├── prayer_times_service.dart # Récupération des heures de prière
│   └── reading_progress_service.dart # Sauvegarde de la progression
└── screens/                     # Écrans de l'application
    ├── prayer_times_screen.dart # Écran des heures de prière
    ├── qibla_screen.dart        # Écran de la boussole Qibla
    ├── juzz_list_screen.dart    # Liste des Juzz
    ├── reading_screen.dart      # Écran de lecture
    └── favorites_screen.dart    # Écran des favoris
```

## Installation

1. **Cloner le projet**
   ```bash
   git clone <url-du-repo>
   cd monwarsflutter
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Lancer l'application**
   ```bash
   flutter run
   ```

## Configuration

### Ressources
Les images du Coran sont situées dans `android/app/src/main/res/drawable/` avec la nomenclature :
- `j1_1.webp` à `j1_45.webp` pour le Juzz 1
- `j2_1.webp` à `j2_42.webp` pour le Juzz 2
- etc.

### Dépendances
- `http: ^1.1.0` : Pour les requêtes HTTP (heures de prière)
- `shared_preferences: ^2.2.2` : Pour le stockage local

## Migration depuis Android Studio

Cette application a été migrée depuis une application Android native vers Flutter. Les anciennes activités Java ont été conservées dans `android/app/src/main/java/com/example/monwarsflutter/` pour référence.

### Fonctionnalités Migrées
- ✅ Liste des Juzz (listeSarr.java → juzz_list_screen.dart)
- ✅ Lecture du Coran (SarrLectureActivity.java → reading_screen.dart)
- ✅ Heures de Prière (PrayerPage.java → prayer_times_screen.dart)
- ✅ Favoris (FavoritesActivity.java → favorites_screen.dart)
- ✅ Suivi de progression (ReadingManager.java → reading_progress_service.dart)

## Captures d'écran

### Écran d'Accueil
- Header avec date et heure
- Cartes pour accéder aux fonctionnalités
- Dernière lecture
- Navigation rapide

### Écran de Lecture
- Navigation entre pages
- Auto-scroll (double-tap pour activer)
- Sauvegarde automatique de la progression

### Écran Heures de Prière
- Récupération automatique des heures
- Coordonnées du Sénégal par défaut
- Interface moderne et colorée

## Contribution

Les contributions sont les bienvenues ! N'hésitez pas à ouvrir une issue ou une pull request.

## Licence

Ce projet est privé et destiné à un usage personnel.
