#!/bin/bash

# Configuration
DB_NAME="db_local_project_prod"
#DB_NAME="db_local_project_test"
DB_USER="dbLocalUsername"
DB_PASS="dbLocalUserpassword"
BACKUP_DIR="/home/hmd/dumps"
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_$(date +\%Y\%m\%d\%H\%M\%S).sql"
REMOTE_HOST="RemoteServerName.fr"
REMOTE_DIR="/home/hmd/dumps"
REMOTE_USER="RemoteServerUserName"
REMOTE_PASS="RemoteServerUserPassword"
REMOTE_MYSQL_USER="dbRemoteUsername"
REMOTE_MYSQL_PASS="dbRemoteUserPassword"
REMOTE_MYSQL_DB="project_backup_monitoring"
REMOTE_MYSQL_PROJECT_DB_NAME="db_remote_project_prod"
#REMOTE_MYSQL_PROJECT_DB_NAME="db_remote_project_test"
PROJECT_NAME="amia_prod"

# Enregistrer le statut sur le serveur distant
log_status() {
    STEP=$1
    STATUS=$2
    MESSAGE=$3
    FILE=$4
    EXEC_TIME=$(date +"%Y-%m-%d %H:%M:%S")
    sshpass -p "$REMOTE_PASS" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$REMOTE_USER@$REMOTE_HOST" "mysql -u $REMOTE_MYSQL_USER -p$REMOTE_MYSQL_PASS $REMOTE_MYSQL_DB -e \"INSERT INTO backup_status (project_name, backup_time, step, status, message, backup_file, exec_time) VALUES ('$PROJECT_NAME', NOW(), '$STEP', '$STATUS', '$MESSAGE', '$FILE', '$EXEC_TIME');\""
}

# Initialiser le statut
log_status "extraction" "not_started" "" "$BACKUP_FILE"
log_status "upload_server" "not_started" "" "$BACKUP_FILE"
log_status "upload_database" "not_started" "" "$BACKUP_FILE"
echo "extraction upload_server upload_database not_started"

# Extraction de la base de données
log_status "extraction" "in_progress" "" "$BACKUP_FILE"
mysqldump --verbose -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_FILE
if [ $? -ne 0 ]; then
    log_status "extraction" "error" "La sauvegarde de la base de données a échoué." "$BACKUP_FILE"
    exit 1
fi
log_status "extraction" "completed" "" "$BACKUP_FILE"

# Transférer la sauvegarde vers le serveur distant avec compression
log_status "upload_server" "in_progress" "" "$BACKUP_FILE"
echo "upload_server in_progress"
sshpass -p "$REMOTE_PASS" scp -C -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$BACKUP_FILE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"
if [ $? -ne 0 ]; then
    log_status "upload_server" "error" "Le transfert de la sauvegarde a échoué." "$BACKUP_FILE"
    echo "upload_server error Le transfert de la sauvegarde a échoué."
    exit 1
fi
log_status "upload_server" "completed" "" "$BACKUP_FILE"
echo "upload_server completed"

# Charger le fichier de sauvegarde dans MySQL sur le serveur distant
log_status "upload_database" "in_progress" "" "$BACKUP_FILE"
echo "upload_database in_progress"
sshpass -p "$REMOTE_PASS" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$REMOTE_USER@$REMOTE_HOST" << EOF
if [ -f "$REMOTE_DIR/$(basename "$BACKUP_FILE")" ]; then
    mysql -u $REMOTE_MYSQL_USER -p$REMOTE_MYSQL_PASS --verbose $REMOTE_MYSQL_PROJECT_DB_NAME < "$REMOTE_DIR/$(basename "$BACKUP_FILE")"
    if [ $? -eq 0 ]; then
        echo "Le fichier de sauvegarde a été chargé avec succès dans MySQL."
    else
        echo "Le chargement du fichier de sauvegarde dans MySQL a échoué."
    fi
else
    echo "Le fichier de sauvegarde n'a pas été trouvé sur le serveur distant."
fi
EOF

if [ $? -ne 0 ]; then
    log_status "upload_database" "error" "Le chargement du fichier de sauvegarde dans MySQL a échoué." "$BACKUP_FILE"
    exit 1
fi
log_status "upload_database" "completed" "" "$BACKUP_FILE"
