# Mishwar — Mauritanie

Projet Floot : `54d64bdf-bde1-4adb-94a9-dfb7835234ec`

Application de transport en arabe RTL pour la Mauritanie.

## Architecture

- Développement et aperçu : Floot
- Versionnement / sauvegarde : GitHub
- CI/CD Android prévu : GitHub Actions
- Base de données actuelle : PostgreSQL gérée par Floot
- OTP : mode développement local sans coût ; fournisseur SMS à brancher pour la production

## Important

Le dépôt `mdv222/codex` contient déjà des CV. Les fichiers Mishwar doivent être ajoutés dans un dossier dédié (`mishwar/`) afin de ne pas modifier les fichiers existants à la racine.

## Pipeline visé

Floot → export/synchronisation du projet → `mishwar/` → GitHub Actions → artefact Android.

Le workflow de compilation sera ajouté lorsque le projet Android exporté sera présent dans `mishwar/`, car Floot construit les applications mobiles avec sa propre couche native et non avec Expo/React Native directement.
