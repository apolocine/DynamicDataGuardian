//DynamicDataGuardian - Instructions de Configuration
//Réalisé par Dr Hamid MADANI
//Le 31/05/2024

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

    $sql = "DELETE FROM backup_status WHERE id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $id);

    if ($stmt->execute()) {
        echo 1;
    } else {
        echo 0;
    }

    $stmt->close();
    $conn->close();
} else {
    echo 0;
}
