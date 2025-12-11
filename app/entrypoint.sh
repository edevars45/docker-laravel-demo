#!/bin/bash
set -e

# Dossier du projet Laravel
cd /var/www/html

echo "=== Démarrage du conteneur Laravel ==="

# Valeurs par défaut pour la base si non définies
DB_HOST="${DB_HOST:-db}"
DB_PORT="${DB_PORT:-3306}"
DB_USERNAME="${DB_USERNAME:-laravel}"
DB_PASSWORD="${DB_PASSWORD:-secret}"

echo "Attente de MySQL sur ${DB_HOST}:${DB_PORT}..."

# On attend que MySQL soit prêt (sans SSL, on est en environnement Docker de dev)
until mysql \
    --protocol=tcp \
    --skip-ssl \
    -h"$DB_HOST" \
    -P"$DB_PORT" \
    -u"$DB_USERNAME" \
    -p"$DB_PASSWORD" \
    -e "SELECT 1" >/dev/null 2>&1; do
    echo "MySQL pas encore prêt, nouvel essai dans 2s..."
    sleep 2
done

echo "☑ MySQL est prêt"

# Vérification (facultative) du .env
if [ ! -f ".env" ]; then
    echo "⚠ Attention : le fichier .env n'existe pas dans /var/www/html"
    echo "   Laravel risque de ne pas fonctionner correctement."
fi

# Valeurs par défaut des flags (false si non définies)
RUN_MIGRATIONS="${RUN_MIGRATIONS:-false}"
RUN_SEEDERS="${RUN_SEEDERS:-false}"

echo "RUN_MIGRATIONS=${RUN_MIGRATIONS}"
echo "RUN_SEEDERS=${RUN_SEEDERS}"

# Lancement des migrations si demandé
if [ "$RUN_MIGRATIONS" = "true" ]; then
    echo "→ Lancement des migrations..."
    if php artisan migrate; then
        echo "☑ Migrations exécutées avec succès."
    else
        echo "⚠ Erreur lors des migrations."
    fi
else
    echo "⏩︎ Migrations désactivées (RUN_MIGRATIONS != true)."
fi

# Lancement des seeders si demandé
if [ "$RUN_SEEDERS" = "true" ]; then
    echo "→ Lancement des seeders..."
    if php artisan db:seed; then
        echo "☑ Seeders exécutés avec succès."
    else
        echo "⚠ Erreur lors de l'exécution des seeders."
    fi
else
    echo "⏩︎ Seeders désactivés (RUN_SEEDERS != true)."
fi

echo "Démarrage d'Apache..."
exec apache2-foreground
