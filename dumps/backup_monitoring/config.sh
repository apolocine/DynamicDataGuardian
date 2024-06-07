# config.sh

# Configuration
DB_NAME="cm_drupal_amia_prod"
DB_USER="htmc"
DB_PASS="gjetfm26"
BACKUP_DIR="/home/hmd/dumps"
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_$(date +\%Y\%m\%d\%H\%M\%S).sql"

REMOTE_USER="hmd"
REMOTE_HOST="amia.fr"
REMOTE_DIR="/home/hmd/dumps"
REMOTE_PASS="hmd"
REMOTE_MYSQL_USER="htmc"
REMOTE_MYSQL_PASS="gjetfm26"
REMOTE_MYSQL_DB="project_backup_monitoring"
REMOTE_MYSQL_PROJECT_DB_NAME="cm_drupal_amia_hmd_prod"
PROJECT_NAME="DynamicDataGuardian"
