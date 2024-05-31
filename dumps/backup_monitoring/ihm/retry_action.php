<?php
include_once 'config.php'; // Inclure le fichier config.php

if (isset($_POST['id'])) {
    $id = $_POST['id'];

    // Créer une connexion
    $conn = new mysqli($servername, $username, $password, $dbname);

    // Vérifier la connexion
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    // Récupérer les informations de la ligne pour relancer l'action
    $sql = "SELECT * FROM backup_status WHERE id = $id";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();

        // Relancer la commande de MySQL
        $backup_file = "/home/hmd/dumps/" . $row['project_name'] . "_" . date("YmdHis", strtotime($row['timestamp'])) . ".sql";
        $remote_mysql_user = "htmc";
        $remote_mysql_pass = "gjetfm26";
        $remote_mysql_project_db_name = "project_backup_test";

        $mysql_command = "mysql -u $remote_mysql_user -p$remote_mysql_pass $remote_mysql_project_db_name < $backup_file 2> retry_error.log";

        exec($mysql_command, $output, $return_var);

        if ($return_var == 0) {
            $sql_update = "UPDATE backup_status SET status='completed', message='Action retried successfully' WHERE id=$id";
            $conn->query($sql_update);
            echo 1;
        } else {
            $error_message = file_get_contents("retry_error.log");
            $sql_update = "UPDATE backup_status SET status='error', message='Retry failed: $error_message' WHERE id=$id";
            $conn->query($sql_update);
            echo 0;
        }
    } else {
        echo 0;
    }

    $conn->close();
}
?>
