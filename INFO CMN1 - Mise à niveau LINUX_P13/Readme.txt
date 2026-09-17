# Script de Monitoring Linux - Nom Prénom

## Objectif
Ce script Shell permet de surveiller en temps réel l’état d’un serveur Linux, en détectant les anomalies critiques et en envoyant des alertes par mail à l’administrateur.

## Fonctionnalités
- Vérification des services critiques (Apache/Nginx, MySQL/MariaDB, SSH)
- Surveillance de l’espace disque
- Détection des processus gourmands en mémoire
- Analyse des échecs de connexion SSH
- Vérification de l’accessibilité réseau
- Envoi d’alertes par mail
- Journalisation horodatée des événements

## Installation
1. Copier le script dans `/usr/local/bin/`
2. Rendre le script exécutable : `chmod +x Nom_Prenom_Monitoring.sh`
3. Ajouter une tâche cron :  
   `*/5 * * * * /usr/local/bin/Nom_Prenom_Monitoring.sh`

## Dépendances
- `mailutils`
- `netcat`
- `systemd`
