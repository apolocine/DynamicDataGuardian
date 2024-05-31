#!/bin/bash
## toutes les minutes * * * * * 
## marquer la date dans le log echo "$(date) - Starting rsync" >> /path/to/log/rsync.log
## && deux commandes successif 
## connexion avec password en ssh sshpass -p 'remote_user_password' rsync -avz -e ssh
## repertoire local /path/to/remote/directory  
## repertoire distant user@remoteHost:/path/to/remote/directory
## stdout des erreurs >> /path/to/log/rsync.log 2>&1

* * * * * echo "$(date) - Starting rsync" >> /path/to/log/rsync.log &&  sshpass -p 'remote_user_password' rsync -avz -e ssh /path/to/remote/directory  hmd@remoteHost:/path/to/remote/directory >> /path/to/log/rsync.log 2>&1
