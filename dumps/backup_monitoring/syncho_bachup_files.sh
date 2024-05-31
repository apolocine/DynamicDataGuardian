#!/bin/bash
## toutes les minutes * * * * * 
## marquer la date dans le log echo "$(date) - Starting rsync" >> /path/to/log/rsync.log
## && deux commandes successif 
## connexion avec password en ssh sshpass -p 'remote_user_password' rsync -avz -e ssh
## repertoire local /path/to/remote/directory  
## repertoire distant user@remoteHost:/path/to/remote/directory
## stdout des erreurs >> /path/to/log/rsync.log 2>&1

# * * * * * echo "$(date) - Starting rsync" >> /path/to/log/rsync.log &&  sshpass -p 'remote_user_password' rsync -avz -e ssh /path/to/remote/directory  hmd@remoteHost:/path/to/remote/directory >> /path/to/log/rsync.log 2>&1


## Définir les variables
LOG_FILE="/patho/to/remote/log/rsync.log"
SOURCE_DIR="/home/hmd/public_html/amia/sites/default/files"
DEST_USER="remote_user"
DEST_HOST="remotehost"
DEST_DIR="/path/to/remote/files"
PASSWORD="remote_user_password"

## Ajouter la date et l'heure dans le fichier de log
##echo "$(date) - Starting rsync" >> $LOG_FILE

## Exécuter la commande rsync avec sshpass pour le mot de passe
echo "$(date) - Starting rsync" >> $LOG_FILE && sshpass -p $PASSWORD rsync -avz -e ssh $SOURCE_DIR $DEST_USER@$DEST_HOST:$DEST_DIR >> $LOG_FILE 2>&1 && echo "$(date) - End rsync ----->" >> $LOG_FILE



