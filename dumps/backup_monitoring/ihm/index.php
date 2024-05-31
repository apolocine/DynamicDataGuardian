
<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
session_start();

include_once 'config.php'; // Inclure le fichier config.php

// Créer une connexion
$conn = new mysqli($servername, $username, $password, $dbname);

// Vérifier la connexion
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Récupérer les noms de projets distincts
$sql_projects = "SELECT DISTINCT project_name FROM backup_status";
$result_projects = $conn->query($sql_projects);
$projects = [];
if ($result_projects->num_rows > 0) {
    while ($row = $result_projects->fetch_assoc()) {
        $projects[] = $row['project_name'];
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Backup Monitoring</title>
    <style>
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 8px;
            text-align: left;
            font-size: 14px;
        }
        th {
            background-color: #f2f2f2;
        }
        .status-not_started {
            background-color: #f9f9f9;
        }
        .status-in_progress {
            background-color: #ffeb3b;
        }
        .status-completed {
            background-color: #4caf50;
            color: white;
        }
        .status-error {
            background-color: #f44336;
            color: white;
        }
        .delete-icon, .retry-icon {
            cursor: pointer;
            margin-right: 5px;
        }
        .delete-icon {
            color: red;
        }
        .retry-icon {
            color: blue;
        }
        .tab {
            display: none;
        }
        .tab.active {
            display: block;
        }
        .tabs {
            display: flex;
            cursor: pointer;
            margin-bottom: 10px;
        }
        .tabs div {
            padding: 10px;
            border: 1px solid black;
            border-bottom: none;
            font-size: 14px;
        }
        .tabs .active {
            background-color: #f2f2f2;
            font-weight: bold;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <div class="container">
        <h1>Backup Monitoring</h1> <a href="about.php">A propos & Install</a>
        <div class="tabs">
            <?php foreach ($projects as $index => $project): ?>
                <div class="tab-link <?php echo $index === 0 ? 'active' : ''; ?>" data-tab="tab-<?php echo $index; ?>">
                    <?php echo $project; ?>
                </div>
            <?php endforeach; ?>
        </div>
        <?php foreach ($projects as $index => $project): ?>
            <?php
            $sql = "SELECT * FROM backup_status WHERE project_name='$project' ORDER BY timestamp DESC";
            $result = $conn->query($sql);
            ?>
            <div id="tab-<?php echo $index; ?>" class="tab <?php echo $index === 0 ? 'active' : ''; ?>">
                <table>
                    <tr>
                        <th>ID</th>
                        <th>Project Name</th>
                        <th>Backup Time</th>
                        <th>Step</th>
                        <th>Status</th>
                        <th>Message</th>
                        <th>Execution Time</th>
                        <th>Timestamp</th>
                        <th>Action</th>
                    </tr>
                    <?php
                    if ($result->num_rows > 0) {
                        while($row = $result->fetch_assoc()) {
                            echo "<tr class='status-" . $row["status"] . "'>";
                            echo "<td>" . $row["id"] . "</td>";
                            echo "<td>" . $row["project_name"] . "</td>";
                            echo "<td>" . $row["backup_time"] . "</td>";
                            echo "<td>" . $row["step"] . "</td>";
                            echo "<td>" . $row["status"] . "</td>";
                            echo "<td>" . $row["message"] . "</td>";
                            echo "<td>" . $row["exec_time"] . "</td>";
                            echo "<td>" . $row["timestamp"] . "</td>";
                            echo "<td><span class='retry-icon' data-id='" . $row["id"] . "'>&#x21bb;</span> <span class='delete-icon' data-id='" . $row["id"] . "'>&#10060;</span></td>"; // retry and delete icons
                            echo "</tr>";
                        }
                    } else {
                        echo "<tr><td colspan='9'>No records found</td></tr>";
                    }
                    ?>
                </table>
            </div>
        <?php endforeach; ?>
        <?php $conn->close(); ?>
    </div>

    <script>
    $(document).ready(function() {
        $('.tab-link').click(function() {
            var tab_id = $(this).data('tab');
            $('.tab-link').removeClass('active');
            $('.tab').removeClass('active');

            $(this).addClass('active');
            $("#" + tab_id).addClass('active');
        });

        $('.retry-icon').click(function() {
            var id = $(this).data('id');
            if (confirm('Are you sure you want to retry this action?')) {
                $.ajax({
                    url: 'retry_action.php',
                    type: 'POST',
                    data: { id: id },
                    success: function(response) {
                        var res = JSON.parse(response);
                        if (res.success) {
                            alert('Action retried successfully');
                        } else {
                            alert('Retry failed: ' + res.message);
                        }
                        location.reload();
                    }
                });
            }
        });

        $('.delete-icon').click(function() {
            var id = $(this).data('id');
            if (confirm('Are you sure you want to delete this record?')) {
                $.ajax({
                    url: 'delete_record.php',
                    type: 'POST',
                    data: { id: id },
                    success: function(response) {
                        if (response == 1) {
                            alert('Record deleted successfully');
                            location.reload();
                        } else {
                            alert('Failed to delete record');
                        }
                    }
                });
            }
        });
    });
    </script>
</body>
</html>
