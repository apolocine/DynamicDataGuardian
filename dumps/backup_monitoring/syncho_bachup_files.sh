#!/bin/bash
## toutes les minutes * * * * * 
## marquer la date dans le log echo "$(date) - Starting rsync" >> /path/to/log/rsync.log
## && deux commandes successif 
## connexion avec password en ssh sshpass -p 'remote_user_password' rsync -avz -e ssh
## repertoire local /path/to/remote/directory  
## repertoire distant user@remoteHost:/path/to/remote/directory
## stdout des erreurs >> /path/to/log/rsync.log 2>&1

# * * * * * echo "$(date) - Starting rsync" >> /path/to/log/rsync.log &&  sshpass -p 'remote_user_password' rsync -avz -e ssh /path/to/remote/directory  hmd@remoteHost:/path/to/remote/directory >> /path/to/log/rsync.log 2>&1


# Définir les variables
LOG_FILE="/home/hmd/public_html/medical_office/hmd_mesra/sites/mesra.amia.fr/files_test/rsync.log"
SOURCE_DIR="/home/hmd/public_html/medical_office/hmd_mesra/sites/mesra.amia.fr/files_test"
DEST_USER="hmd"
DEST_HOST="amia.fr"
DEST_DIR="/home/hmd/private_html/medical_office/hmd_mesra/sites/mesra.amia.fr/files_test"
PASSWORD="hmd"

# Ajouter la date et l'heure dans le fichier de log
echo "$(date) - Starting rsync" >> $LOG_FILE

# Exécuter la commande rsync avec sshpass pour le mot de passe
sshpass -p $PASSWORD rsync -avz -e ssh $SOURCE_DIR $DEST_USER@$DEST_HOST:$DEST_DIR >> $LOG_FILE 2>&1
