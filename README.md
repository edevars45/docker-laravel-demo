# Docker Compose - Laravel Miniblog

![Laravel](https://img.shields.io/badge/Laravel-12.39-FF2D20?style=flat-square&logo=laravel)
![PHP](https://img.shields.io/badge/PHP-8.4-777BB4?style=flat-square&logo=php)
![MySQL](https://img.shields.io/badge/MySQL-8.4-4479A1?style=flat-square&logo=mysql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?style=flat-square&logo=docker)

Application de blog minimaliste développée avec Laravel, orchestrée avec Docker Compose pour un déploiement rapide et reproductible.

## Table des Matières

- [Fonctionnalités](#fonctionnalités)
- [Prérequis](#prérequis)
- [Installation](#installation)
- [Architecture](#architecture)
- [Utilisation](#utilisation)
- [Commandes Utiles](#commandes-utiles)
- [Backup & Restore](#backup--restore)
- [Technologies](#technologies)
- [Troubleshooting](#troubleshooting)
- [Licence](#licence)

## Fonctionnalités

- Système d'authentification complet (Laravel Breeze)
- Gestion des articles de blog (CRUD)
- Système de rôles et permissions (admin, éditeur, auteur)
- Interface d'administration
- Vue publique des articles publiés
- Design responsive avec Tailwind CSS
- Stack complète dockerisée

## Prérequis

- [Docker Desktop](https://www.docker.com/products/docker-desktop) (version 20.10+)
- [Git](https://git-scm.com/)
- 4 Go de RAM disponible
- Ports libres : 8000 (Laravel), 8080 (phpMyAdmin)

## Installation

### 1. Cloner le dépôt
```bash
git clone https://github.com/edevars45/docker-laravel-demo.git
cd docker-laravel-demo
```

### 2. Lancer Docker Compose
```bash
docker compose up -d --build
```

### 3. Configuration de Laravel
```bash
# Installer les dépendances PHP
docker compose exec app composer install

# Configurer l'environnement
docker compose exec app cp .env.example .env
docker compose exec app php artisan key:generate

# Créer les tables et insérer les données de test
docker compose exec app php artisan migrate --seed

# Compiler les assets CSS/JS
docker compose exec app npm install
docker compose exec app npm run build
```

### 4. Accéder à l'application

- **Laravel Miniblog :** http://localhost:8000
- **phpMyAdmin :** http://localhost:8080
  - Serveur : `db`
  - Utilisateur : `minibloguser`
  - Mot de passe : `secret`

### 5. Comptes de test

| Email | Mot de passe | Rôle |
|-------|--------------|------|
| toto@mail.com | password | Admin |
| titi@mail.com | password | Éditeur |
| tata@mail.com | password | Auteur |
| tutu@mail.com | password | Auteur |

## Architecture
```
docker-laravel-demo/
├── app/                          # Configuration Docker
│   ├── Dockerfile                # Image PHP 8.4 + Apache
│   ├── entrypoint.sh             # Script de démarrage
│   └── vhost.conf                # Configuration Apache
├── src/                          # Code source Laravel
├── .env                          # Variables d'environnement Docker
├── docker-compose.yaml           # Orchestration des services
└── README.md
```

### Services Docker

| Service | Image | Port | Description |
|---------|-------|------|-------------|
| **app** | PHP 8.4 + Apache | 8000 | Application Laravel |
| **db** | MySQL 8.4 | 3306 | Base de données |
| **phpmyadmin** | phpMyAdmin | 8080 | Interface MySQL |

## Utilisation

### Démarrage quotidien
```bash
# Démarrer les conteneurs
docker compose start

# Arrêter les conteneurs (garde les données)
docker compose stop
```

### Voir les logs
```bash
# Logs de tous les services
docker compose logs -f

# Logs d'un service spécifique
docker compose logs -f app
```

### Accéder au shell
```bash
# Shell PHP/Apache
docker compose exec app bash

# Client MySQL
docker compose exec db mysql -u minibloguser -psecret miniblog
```

## Commandes Utiles

### Laravel Artisan
```bash
# Lancer des migrations
docker compose exec app php artisan migrate

# Créer un nouveau modèle
docker compose exec app php artisan make:model NomDuModele

# Créer un contrôleur
docker compose exec app php artisan make:controller NomController

# Nettoyer le cache
docker compose exec app php artisan cache:clear
```

### Assets (Vite)
```bash
# Mode développement (hot reload)
docker compose exec app npm run dev

# Compilation pour production
docker compose exec app npm run build
```

### Composer
```bash
# Installer une nouvelle dépendance
docker compose exec app composer require vendor/package

# Mettre à jour les dépendances
docker compose exec app composer update
```

## Backup & Restore

### Créer un backup MySQL
```bash
docker compose exec db mysqldump -u minibloguser -psecret --no-tablespaces miniblog > backup.sql
```

### Restaurer un backup
```bash
# 1. Créer les tables
docker compose exec app php artisan migrate

# 2. Importer les données
docker compose exec -T db mysql -u minibloguser -psecret miniblog < backup.sql
```

## Cycle de vie des conteneurs

### Arrêt et suppression (garde les données)
```bash
# Supprime les conteneurs mais GARDE les volumes (données MySQL)
docker compose down

# Relancer
docker compose up -d
```

### Suppression complète (efface TOUT)
```bash
# ATTENTION : Supprime conteneurs + volumes (données perdues)
docker compose down -v

# Pour recréer l'environnement
docker compose up -d --build
# Puis refaire toute la configuration (composer, migrate, etc.)
```

## Technologies

### Backend
- **PHP** 8.4
- **Laravel** 12.39
- **MySQL** 8.4
- **Apache** 2.4

### Frontend
- **Vite** 7.2
- **Tailwind CSS** 3.x
- **Laravel Breeze** (authentification)

### DevOps
- **Docker** & **Docker Compose**
- **phpMyAdmin**

### Packages Laravel
- `spatie/laravel-permission` - Gestion des rôles et permissions
- `laravel/breeze` - Authentification
- `laravel/tinker` - REPL
- `laravel/pail` - Logs en temps réel

## Troubleshooting

### L'application ne se lance pas
```bash
# Vérifier les logs
docker compose logs app

# Vérifier l'état des conteneurs
docker compose ps
```

### Erreur "vendor/autoload.php not found"
```bash
docker compose exec app composer install
```

### Erreur "Vite manifest not found"
```bash
docker compose exec app npm install
docker compose exec app npm run build
```

### Erreur "Table doesn't exist"
```bash
docker compose exec app php artisan migrate --seed
```

### Port déjà utilisé (8000 ou 8080)

Modifier les ports dans `docker-compose.yaml` :
```yaml
services:
  app:
    ports:
      - "9000:80"  # Au lieu de 8000:80
```

## Structure de la base de données

Tables principales :
- `users` - Utilisateurs
- `posts` - Articles de blog
- `roles` - Rôles (admin, éditeur, auteur)
- `permissions` - Permissions
- `role_has_permissions` - Association rôles-permissions
- `model_has_roles` - Association utilisateurs-rôles

## Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :

1. Fork le projet
2. Créer une branche (`git checkout -b feature/AmazingFeature`)
3. Commit vos changements (`git commit -m 'Add AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## Auteur

**Esther Devars**

- GitHub: [@edevars45](https://github.com/edevars45)

## Remerciements

- [Laravel](https://laravel.com/) - Framework PHP
- [Docker](https://www.docker.com/) - Containerisation
- [Tailwind CSS](https://tailwindcss.com/) - Framework CSS
- [Spatie](https://spatie.be/) - Package de permissions

---

Si ce projet vous a été utile, n'oubliez pas de lui donner une étoile !