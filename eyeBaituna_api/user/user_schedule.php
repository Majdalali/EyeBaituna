<?php
include '../connection.php';

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Update or Create Schedule Dates
    if (!isset($_POST['user_id']) || !isset($_POST['start_date']) || !isset($_POST['end_date'])) {
        http_response_code(400);
        echo json_encode(array("success" => false, "message" => "User ID, start date, or end date parameter is missing"));
        exit();
    }

    $user_id = $_POST['user_id'];
    $start_date = $_POST['start_date'];
    $end_date = $_POST['end_date'];

    // Check if the user already has a schedule
    $checkQuery = "SELECT * FROM schedule WHERE user_id = ?";
    $checkStmt = $conn->prepare($checkQuery);
    $checkStmt->bind_param("i", $user_id);
    $checkStmt->execute();
    $checkResult = $checkStmt->get_result();

    if ($checkResult->num_rows > 0) {
        // Update existing schedule
        $updateQuery = "UPDATE schedule SET start_date = ?, end_date = ? WHERE user_id = ?";
        $updateStmt = $conn->prepare($updateQuery);
        $updateStmt->bind_param("ssi", $start_date, $end_date, $user_id);

        if ($updateStmt->execute()) {
            // Success - Schedule dates have been updated
            echo json_encode(array("success" => true, "message" => "Schedule dates have been updated successfully"));
        } else {
            // Error occurred while updating schedule dates
            http_response_code(500);
            echo json_encode(array("success" => false, "message" => "Failed to update schedule dates"));
        }
    } else {
        // Create new schedule
        $insertQuery = "INSERT INTO schedule (user_id, start_date, end_date) VALUES (?, ?, ?)";
        $insertStmt = $conn->prepare($insertQuery);
        $insertStmt->bind_param("iss", $user_id, $start_date, $end_date);

        if ($insertStmt->execute()) {
            // Success - New schedule has been assigned
            echo json_encode(array("success" => true, "message" => "New schedule has been assigned successfully"));
        } else {
            // Error occurred while inserting new schedule
            http_response_code(500);
            echo json_encode(array("success" => false, "message" => "Failed to assign new schedule"));
        }
    }
} elseif ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Fetch Schedule Dates
    if (isset($_GET['user_id'])) {
        $user_id = $_GET['user_id'];
    } else {
        // Bad request - user ID parameter is missing
        http_response_code(400);
        echo json_encode(array("success" => false, "message" => "User ID parameter is missing"));
        exit();
    }
    
    $sqlQuery = "SELECT start_date, end_date FROM schedule WHERE user_id = ?";
    $stmt = $conn->prepare($sqlQuery);
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $start_date = $row['start_date'];
        $end_date = $row['end_date'];
        
        echo json_encode(array("success" => true, "start_date" => $start_date, "end_date" => $end_date));
    } else {
        echo json_encode(array("success" => false, "message" => "Failed to fetch schedule dates"));
    }
} else {
    // Method not allowed
    http_response_code(405);
    echo json_encode(array("success" => false, "message" => "Method not allowed"));
    exit();
}
?>
