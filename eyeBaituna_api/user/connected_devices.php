<?php
include '../connection.php';

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Add Bandwidth to Device
    if (!isset($_POST['device_id']) || !isset($_POST['bandwidth'])) {
        // Bad request - required parameters are missing
        http_response_code(400);
        echo json_encode(array("success" => false, "message" => "Device ID or bandwidth parameter is missing"));
        exit();
    }

    $device_id = $_POST['device_id'];
    $bandwidth = $_POST['bandwidth'];

    $sqlQuery = "UPDATE connected_devices SET bandwidth_limit = ? WHERE id = ?";
    $stmt = $conn->prepare($sqlQuery);
    $stmt->bind_param("ii", $bandwidth, $device_id);

    if ($stmt->execute()) {
        // Success - Bandwidth has been added to the device
        echo json_encode(array("success" => true, "message" => "Bandwidth has been added to the device successfully"));
    } else {
        // Error occurred while adding bandwidth to the device
        http_response_code(500);
        echo json_encode(array("success" => false, "message" => "Failed to add bandwidth to the device"));
    }
} elseif ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Fetch Device Information
    if (isset($_GET['user_id'])) {
        $user_id = $_GET['user_id'];
    } else {
        // Bad request - user ID parameter is missing
        http_response_code(400);
        echo json_encode(array("success" => false, "message" => "User ID parameter is missing"));
        exit();
    }
    
    $sqlQuery = "SELECT id, device_name, bandwidth_limit FROM connected_devices WHERE user_id = ?";
    $stmt = $conn->prepare($sqlQuery);
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result) {
        $devices = array();
        while ($row = $result->fetch_assoc()) {
            $devices[] = array(
                "id" => $row['id'],
                "device_name" => $row['device_name'],
                "bandwidth_limit" => $row['bandwidth_limit']
            );
        }
        echo json_encode(array("success" => true, "devices" => $devices));
    } else {
        echo json_encode(array("success" => false, "message" => "Failed to fetch device information"));
    }
} else {
    // Method not allowed
    http_response_code(405);
    echo json_encode(array("success" => false, "message" => "Method not allowed"));
    exit();
}
?>
