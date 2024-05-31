#!
* * * * * echo "$(date) - Starting rsync" >> /path/to/log/rsync.log &&  sshpass -p 'remote_user_password' rsync -avz -e ssh /path/to/remote/directory  hmd@amia.fr:/path/to/remote/directory >> /path/to/log/rsync.log 2>&1
