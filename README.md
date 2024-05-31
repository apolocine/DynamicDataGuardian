# DynamicDataGuardian
DynamicDataGuardian est un script automatisé de sauvegarde et de synchronisation de bases de données, conçu pour assurer la protection, la fiabilité et la sécurité de vos données SQL.
<h3>Fonctionnalités Clés</h3>
<ol>
<li><strong>Sauvegarde Automatisée</strong> : Effectue des sauvegardes régulières de vos bases de données MySQL.</li>
<li><strong>Transfert Sécurisé</strong> : Transfère les sauvegardes vers un serveur distant en utilisant SCP avec compression pour une vitesse optimale.</li>
<li><strong>Chargement dans MySQL</strong> : Charge automatiquement les sauvegardes dans une base de données MySQL distante.</li>
<li><strong>Suivi des Statuts</strong> : Enregistre les statuts des différentes étapes de sauvegarde dans une base de données de monitoring.</li>
<li><strong>Notifications</strong> : Envoie des notifications en cas de succès ou d'échec des différentes étapes.</li></ol>
<h3>Mise en Œuvre</h3>
<h4>Script Principal</h4>
<p>Le script principal restera comme mentionné précédemment, mais avec le nom de projet intégré dans les messages de log et la documentation.</p>
<h4>Documentation</h4>
<p>
   La documentation sur l'installation, la configuration et l'utilisation de DynamicDataGuardian.
</p>





    <h1>DynamicDataGuardian - Instructions de Configuration</h1>
    <p>Réalisé par Dr Hamid MADANI</p>
    <p>Le 31/05/2024</p>

    <h2>1. Sur le serveur distant</h2>

    <h3>1.1 MySQL</h3>
    <p>Créer la base de données et la table pour le suivi des statuts de sauvegarde :</p>
    <pre><code>
CREATE DATABASE project_backup_monitoring;
USE project_backup_monitoring;
CREATE TABLE `backup_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_name` varchar(255) NOT NULL,
  `backup_time` datetime NOT NULL,
  `step` varchar(255) NOT NULL,
  `status` enum('not_started','in_progress','completed','error') NOT NULL,
  `message` text,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `exec_time` datetime DEFAULT NULL,
  `backup_file` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
    </code></pre>

    <h3>1.2 Créer le site Web</h3>
    <p>Copiez les fichiers du site Web vers le répertoire du serveur :</p>
    <ul>
        <li>index.php</li>
        <li>config.php</li>
        <li>delete_record.php</li>
        <li>jquery-3.6.0.min.js</li>
        <li>retry_action.php</li>
    </ul>

    <h3>1.3 Mettre à jour les données de configuration</h3>
    <p>Éditez <code>config.php</code> pour y inclure les informations de connexion à la base de données :</p>
    <pre><code>
<?php
// Connexion à la base de données (à personnaliser avec vos propres informations de connexion)
$servername = "localhost";
$username = "monitor_user";
$password = "monitor_pass@26";
$dbname = "project_backup_monitoring";
?>
    </code></pre>

    <h3>1.4 Créer le répertoire de sauvegarde</h3>
    <p>Créez le répertoire de sauvegarde sur le serveur distant :</p>
    <pre><code>
sudo mkdir /path/to/dumps
sudo chmod 777 /path/to/dumps
    </code></pre>

    <h2>2. Sur le serveur local</h2>

    <h3>2.1 Créer les répertoires pour les données et les scripts shell</h3>
    <p>Créez les répertoires nécessaires et configurez les permissions :</p>
    <pre><code>
sudo mkdir /path/to/dumps
sudo chmod 777 /path/to/dumps

sudo mkdir /path/to/sh_scripts
sudo chmod 777 /path/to/sh_scripts
    </code></pre>

    <h3>2.2 Préparer le script <code>backup_and_upload.sh</code></h3>
    <p>Copiez <code>backup_and_upload.sh</code> dans le répertoire des scripts shell :</p>
    <pre><code>
cp backup_and_upload.sh /path/to/sh_scripts/backup_and_upload.sh
    </code></pre>
    <p>Si vous rencontrez des problèmes de codage UTF-8, exécutez la commande suivante :</p>
    <pre><code>
dos2unix /path/to/sh_scripts/backup_and_upload.sh
    </code></pre>

    <h3>2.3 Automatiser l'exécution du script avec cron</h3>
    <p>Ajoutez le script au cron pour qu'il s'exécute automatiquement tous les jours à 19 heures :</p>
    <pre><code>
EDITOR=nano crontab -e
    </code></pre>
    <p>Ajoutez la ligne suivante au fichier crontab :</p>
    <pre><code>
0 19 * * * /path/to/sh_scripts/backup_and_upload.sh >> /path/to/backup_and_upload.log 2>&1
    </code></pre>

    <h3>Exemple complet de <code>backup_and_upload.sh</code></h3>
    <p>Voici une version complète et ajustée du script <code>backup_and_upload.sh</code> :</p>
    <pre><code>
#!/bin/bash

# Réalisé par Dr Hamid MADANI
# Le 31/05/2024

# Configuration
DB_NAME="cm_drupal_amia_prod"
DB_USER="htmc"
DB_PASS="gjetfm26"
BACKUP_DIR="/path/to/dumps"
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_$(date +\%Y\%m\%d\%H\%M\%S).sql"

REMOTE_USER="hmd"
REMOTE_HOST="amia.fr"
REMOTE_DIR="/path/to/dumps"
REMOTE_PASS="hmd"
REMOTE_MYSQL_USER="htmc"
REMOTE_MYSQL_PASS="gjetfm26"
REMOTE_MYSQL_DB="project_backup_monitoring"
REMOTE_MYSQL_PROJECT_DB_NAME="project_backup_test"
PROJECT_NAME="DynamicDataGuardian"

# Enregistrer le statut sur le serveur distant
log_status() {
    STEP=$1
    STATUS=$2
    MESSAGE=$3
    EXEC_TIME=$(date +"%Y-%m-%d %H:%M:%S")
    sshpass -p "$REMOTE_PASS" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$REMOTE_USER@$REMOTE_HOST" \
    "mysql -u $REMOTE_MYSQL_USER -p$REMOTE_MYSQL_PASS $REMOTE_MYSQL_DB -e \"INSERT INTO backup_status (project_name, backup_time, step, status, message, exec_time) VALUES ('$PROJECT_NAME', NOW(), '$STEP', '$STATUS', '$MESSAGE', '$EXEC_TIME');\""
}

# Initialiser le statut
log_status "extraction" "not_started" ""
log_status "upload_server" "not_started" ""
log_status "upload_database" "not_started" ""
echo "$PROJECT_NAME: extraction upload_server upload_database not_started"

# Extraction de la base de données
log_status "extraction" "in_progress" ""
mysqldump -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$BACKUP_FILE" 2> /tmp/mysqldump_error.log
if [ $? -ne 0 ]; then
    ERROR_MSG=$(cat /tmp/mysqldump_error.log)
    log_status "extraction" "error" "La sauvegarde de la base de données a échoué: $ERROR_MSG"
    exit 1
fi
log_status "extraction" "completed" ""

# Transférer la sauvegarde vers le serveur distant avec compression
log_status "upload_server" "in_progress" ""
echo "$PROJECT_NAME: upload_server in_progress"
sshpass -p "$REMOTE_PASS" scp -C -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$BACKUP_FILE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR" 2> /tmp/scp_error.log
if [ $? -ne 0 ]; then
    ERROR_MSG=$(cat /tmp/scp_error.log)
    log_status "upload_server" "error" "Le transfert de la sauvegarde a échoué: $ERROR_MSG"
    echo "$PROJECT_NAME: upload_server error Le transfert de la sauvegarde a échoué: $ERROR_MSG"
    exit 1
fi
log_status "upload_server" "completed" ""
echo "$PROJECT_NAME: upload_server completed"

# Charger le fichier de sauvegarde dans MySQL sur le serveur distant
log_status "upload_database" "in_progress" ""
echo "$PROJECT_NAME: upload_database in_progress"
sshpass -p "$REMOTE_PASS" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$REMOTE_USER@$REMOTE_HOST" << EOF
if [ -f "$REMOTE_DIR/$(basename "$BACKUP_FILE")" ]; then
    mysql -u $REMOTE_MYSQL_USER -p$REMOTE_MYSQL_PASS $REMOTE_MYSQL_PROJECT_DB_NAME < "$REMOTE_DIR/$(basename "$BACKUP_FILE")" 2> /tmp/mysql_error.log
    if [ \$? -eq 0 ]; then
        echo "Le fichier de sauvegarde a été chargé avec succès dans MySQL."
    else
        ERROR_MSG=\$(cat /tmp/mysql_error.log)
        echo "Le chargement du fichier de sauvegarde dans MySQL a échoué: \$ERROR_MSG"
    fi
else
    echo "Le fichier de sauvegarde n'a pas été trouvé sur le serveur distant."
fi
EOF

if [ $? -ne 0 ]; then
    ERROR_MSG=$(sshpass -p "$REMOTE_PASS" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$REMOTE_USER@$REMOTE_HOST" "cat /tmp/mysql_error.log")
    log_status "upload_database" "error" "Le chargement du fichier de sauvegarde dans MySQL a échoué: $ERROR_MSG"
    exit 1
fi
log_status "upload_database" "completed" ""
    </code></pre>

