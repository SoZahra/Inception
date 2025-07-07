#!/bin/bash

echo "=== DÉMONSTRATION SERVICE BACKUP ==="

echo "1. Vérifier le statut du container backup :"
docker ps | grep backup

echo -e "\n2. Vérifier les logs de démarrage :"
docker logs backup | head -15

echo -e "\n3. Voir les backups existants :"
docker exec backup ls -la /backups

echo -e "\n4. Détails d'un backup :"
LATEST_BACKUP=$(docker exec backup ls -1 /backups | grep backup_ | tail -1)
if [ ! -z "$LATEST_BACKUP" ]; then
    echo "Contenu du backup: $LATEST_BACKUP"
    docker exec backup ls -la /backups/$LATEST_BACKUP
    echo ""
    echo "Informations du backup :"
    docker exec backup cat /backups/$LATEST_BACKUP/backup_info.txt
fi

echo -e "\n5. Test backup manuel :"
echo "Lancement d'un backup manuel..."
docker exec backup /usr/local/bin/backup.sh

echo -e "\n6. Vérifier les logs détaillés :"
docker exec backup tail -10 /var/log/backup/backup.log

echo -e "\n=== INFORMATIONS SERVICE BACKUP ==="
echo "📁 Répertoire backups: /backups"
echo "🗄️  Base de données: WordPress DB"
echo "📦 Format: .sql.gz + .tar.gz"
echo "⏰ Fréquence: Toutes les 6h + manuel"
echo "🗑️  Rétention: 7 jours"
echo "✅ Vérification intégrité automatique"

echo -e "\n=== COMMANDES UTILES ==="
echo "Backup manuel: docker exec backup /usr/local/bin/backup.sh"
echo "Voir backups: docker exec backup ls -la /backups"
echo "Voir logs: docker exec backup cat /var/log/backup/backup.log"

echo -e "\n=== JUSTIFICATION ==="
echo "✅ Service critique pour la continuité de service"
echo "✅ Protection des données WordPress et base"
echo "✅ Automatisation des sauvegardes"
echo "✅ Compression et optimisation espace"
echo "✅ Vérification intégrité des backups"
echo "✅ Nettoyage automatique des anciens backups"
