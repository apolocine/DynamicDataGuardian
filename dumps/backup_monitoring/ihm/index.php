<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Backup Monitoring</title>
    <style>
        /* Add your existing styles */
        .tabs {
            overflow: hidden;
            background-color: #f1f1f1;
        }
        .tabs button {
            background-color: inherit;
            float: left;
            border: none;
            outline: none;
            cursor: pointer;
            padding: 14px 16px;
            transition: 0.3s;
        }
        .tabs button:hover {
            background-color: #ddd;
        }
        .tabs button.active {
            background-color: #ccc;
        }
        .tabcontent {
            display: none;
            padding: 6px 12px;
            border: 1px solid #ccc;
            border-top: none;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <h1>Backup Monitoring</h1>
    <div class="tabs">
        <?php foreach ($projects as $project_name => $project_data): ?>
            <button class="tablinks" onclick="openProject(event, '<?php echo $project_name; ?>')"><?php echo $project_name; ?></button>
        <?php endforeach; ?>
    </div>

    <?php foreach ($projects as $project_name => $project_data): ?>
        <div id="<?php echo $project_name; ?>" class="tabcontent">
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
                <?php foreach ($project_data as $row): ?>
                    <tr class='status-<?php echo $row["status"]; ?>'>
                        <td><?php echo $row["id"]; ?></td>
                        <td><?php echo $row["project_name"]; ?></td>
                        <td><?php echo $row["backup_time"]; ?></td>
                        <td><?php echo $row["step"]; ?></td>
                        <td><?php echo $row["status"]; ?></td>
                        <td><?php echo $row["message"]; ?></td>
                        <td><?php echo $row["exec_time"]; ?></td>
                        <td><?php echo $row["timestamp"]; ?></td>
                        <td>
                            <span class='delete-icon' data-id='<?php echo $row["id"]; ?>'>&#10060;</span>
                            <?php if ($row["status"] == "error"): ?>
                                <span class='retry-icon' data-id='<?php echo $row["id"]; ?>'>&#8635;</span>
                            <?php endif; ?>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </table>
        </div>
    <?php endforeach; ?>

    <script>
    function openProject(evt, projectName) {
        var i, tabcontent, tablinks;
        tabcontent = document.getElementsByClassName("tabcontent");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
        }
        tablinks = document.getElementsByClassName("tablinks");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
        }
        document.getElementById(projectName).style.display = "block";
        evt.currentTarget.className += " active";
    }

    $(document).ready(function() {
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

        $('.retry-icon').click(function() {
            var id = $(this).data('id');
            if (confirm('Are you sure you want to retry this action?')) {
                $.ajax({
                    url: 'retry_action.php',
                    type: 'POST',
                    data: { id: id },
                    success: function(response) {
                        if (response == 1) {
                            alert('Action retried successfully');
                            location.reload();
                        } else {
                            alert('Failed to retry action');
                        }
                    }
                });
            }
        });
    });
    </script>
</body>
</html>
