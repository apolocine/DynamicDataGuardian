## sudo apt-get install percona-toolkit
## >synchronisation incrémentielle des données serveur local
#!/bin/bash

# Définir les variables pour les bases de données
SOURCE_DB="db_dev01"
TARGET_DB="db_dev02"
USER="your_mysql_user"
PASSWORD="your_mysql_password"
HOST="localhost"

# Synchroniser les tables
pt-table-sync --execute --verbose h=$HOST,D=$SOURCE_DB,u=$USER,p=$PASSWORD h=$HOST,D=$TARGET_DB,u=$USER,p=$PASSWORD

echo "Synchronisation incrémentielle terminée avec succès."
