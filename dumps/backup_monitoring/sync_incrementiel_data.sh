## sudo apt-get install percona-toolkit
## >synchronisation incrémentielle des données
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
#!/bin/bash

# Définir les variables pour les bases de données
SOURCE_DB="db_dev01"
TARGET_DB="db_dev02"
USER="your_mysql_user"
PASSWORD="your_mysql_password"
SOURCE_HOST="source_host"
TARGET_HOST="target_host"
LOG_FILE="/var/log/db_sync.log"

# Synchroniser de source à cible
echo "$(date) - Starting sync from $SOURCE_DB to $TARGET_DB" >> $LOG_FILE
pt-table-sync --execute --verbose h=$SOURCE_HOST,D=$SOURCE_DB,u=$USER,p=$PASSWORD h=$TARGET_HOST,D=$TARGET_DB,u=$USER,p=$PASSWORD >> $LOG_FILE 2>&1
echo "$(date) - Sync from $SOURCE_DB to $TARGET_DB completed" >> $LOG_FILE

# Synchroniser de cible à source
echo "$(date) - Starting sync from $TARGET_DB to $SOURCE_DB" >> $LOG_FILE
pt-table-sync --execute --verbose h=$TARGET_HOST,D=$TARGET_DB,u=$USER,p=$PASSWORD h=$SOURCE_HOST,D=$SOURCE_DB,u=$USER,p=$PASSWORD >> $LOG_FILE 2>&1
echo "$(date) - Sync from $TARGET_DB to $SOURCE_DB completed" >> $LOG_FILE

echo "$(date) - Bidirectional synchronization completed successfully." >> $LOG_FILE
