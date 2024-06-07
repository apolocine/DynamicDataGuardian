# config.sh


# Réalisé par Dr Hamid MADANI
# Le 31/05/2024

# Configuration
DB_NAME="cm_drupal_amia_prod"
DB_USER="local_user_name"
DB_PASS="*****"
BACKUP_DIR="/home/hmd/dumps"
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_$(date +\%Y\%m\%d\%H\%M\%S).sql"

REMOTE_USER="remot_user_name"
REMOTE_HOST="remote_host_name.fr"
REMOTE_DIR="/home/hmd/dumps"
REMOTE_PASS="remot_pass"
REMOTE_MYSQL_USER="user"
REMOTE_MYSQL_PASS="*****"
REMOTE_MYSQL_DB="project_backup_monitoring"
REMOTE_MYSQL_PROJECT_DB_NAME="cm_drupal_amia_hmd_prod"
PROJECT_NAME="DynamicDataGuardian"
