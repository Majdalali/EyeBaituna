<?php
include '../connection.php';

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Fetch Internet Switch Status
    if (isset($_GET['user_id'])) {
        $user_id = $_GET['user_id'];
    } else {
        // Bad request - user ID parameter is missing
        http_response_code(400);
        echo json_encode(array("success" => false, "message" => "User ID parameter is missing"));
        exit();
    }

    $sqlQuery = "SELECT switch_status, switch_value FROM internet_switch WHERE user_id = ?";
    $stmt = $conn->prepare($sqlQuery);
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $switch_status = $row['switch_status'];
        $switch_value = $row['switch_value'];

        echo json_encode(array("success" => true, "switch_status" => $switch_status, "switch_value" => $switch_value));
    } else {
        echo json_encode(array("success" => false, "message" => "Failed to fetch internet switch status"));
    }
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Update or Insert Internet Switch Status
    if (!isset($_POST['user_id']) || !isset($_POST['switch_status']) || !isset($_POST['switch_value'])) {
        http_response_code(400);
        echo json_encode(array("success" => false, "message" => "User ID, switch status, or switch value parameter is missing"));
        exit();
    }

    $user_id = $_POST['user_id'];
    $switch_status = $_POST['switch_status'];
    $switch_value = $_POST['switch_value'];

    // Check if the internet switch record already exists for the user
    $sqlQuery = "SELECT id FROM internet_switch WHERE user_id = ?";
    $stmt = $conn->prepare($sqlQuery);
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        // Update existing internet switch record
        $updateQuery = "UPDATE internet_switch SET switch_status = ?, switch_value = ? WHERE user_id = ?";
        $stmt = $conn->prepare($updateQuery);
        $stmt->bind_param("sii", $switch_status, $switch_value, $user_id);
        $stmt->execute();
        echo json_encode(array("success" => true, "message" => "Internet switch status has been updated successfully"));
    } else {
        // Insert new internet switch record
        $insertQuery = "INSERT INTO internet_switch (user_id, switch_status, switch_value) VALUES (?, ?, ?)";
        $stmt = $conn->prepare($insertQuery);
        $stmt->bind_param("iss", $user_id, $switch_status, $switch_value);
        $stmt->execute();
        echo json_encode(array("success" => true, "message" => "Internet switch status has been inserted successfully"));
    }
} else {
    // Method not allowed
    http_response_code(405);
    echo json_encode(array("success" => false, "message" => "Method not allowed"));
    exit();
}
?>
