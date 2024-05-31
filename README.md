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


#Réalisé par Dr Hamid MADANI 
#Le 31/05/2024

1 On remote server:

 1.1 MySQL
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

1.2 Create Web Site 
    copie ihm directry to the server directory site
      index.php
      config.php
      delete_record.php
      jquery-3.6.0.min.js
      retry_action.php

1.3 Update config data 
    Edit config.php 
    // Connexion à la base de données (à personnaliser avec vos propres informations de connexion)
       $servername = "localhost";
       $username = "monitor_user";
       $password = "monitor_pass@26";
       $dbname = "project_backup_monitoring";

 1.4 Create Data Directory
      sudo mkdir /path/to/dumps"

2 On Local Server
 1.2 Make data and shel Script directory,
      sudo mkdir /path/to/dumps
      sudo chmod 777 /path/to/dumps

      sudo mkdir /path/to/sh_scripts
      sudo chmod 777 /path/to/sh_scripts

 1.3  prepare backup_and_upload.sh
       copy backup_and_upload.sh to /path/to/sh_scripts/backup_and_upload.sh
       if UTF-8 problème execute 
       dos2unix ./backup_and_upload.sh
       
1.4  Automatiser l'execution du scripte sh
     Ajouter au cron la ligne suivante  with promt 
      $EDITOR=nano crontab -e
      0 19 * * * /path/to/backup_and_upload_test.sh >> /path/to/backup_and_upload.log 2>&1

