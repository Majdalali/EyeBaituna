<?php
include '../connection.php';

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Ban URL
    if (!isset($_POST['url']) || !isset($_POST['user_id'])) {
        // Bad request - required parameters are missing
        http_response_code(400);
        echo json_encode(array("success" => false, "message" => "URL or user ID parameter is missing"));
        exit();
    }

    $url = $_POST['url'];
    $user_id = $_POST['user_id'];

    $sqlQuery = "INSERT INTO banned_urls (url, user_id) VALUES (?, ?)";
    $stmt = $conn->prepare($sqlQuery);
    $stmt->bind_param("si", $url, $user_id);

    if ($stmt->execute()) {
        // Success - URL has been added to the database
        echo json_encode(array("success" => true, "message" => "Website has been blocked successfully"));
    } else {
        // Error occurred while inserting the URL
        http_response_code(500);
        echo json_encode(array("success" => false, "message" => "Failed to block website"));
    }
} elseif ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Fetch banned URLs
    $sqlQuery = "SELECT url FROM banned_urls WHERE user_id = ?";
    $stmt = $conn->prepare($sqlQuery);
    
    if (isset($_GET['user_id'])) {
        $user_id = $_GET['user_id'];
    } else {
        // Bad request - user ID parameter is missing
        http_response_code(400);
        echo json_encode(array("success" => false, "message" => "User ID parameter is missing"));
        exit();
    }
    
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result) {
        $urls = array();
        while ($row = $result->fetch_assoc()) {
            $urls[] = $row['url'];
        }
        echo json_encode(array("success" => true, "urls" => $urls));
    } else {
        echo json_encode(array("success" => false, "message" => "Failed to fetch banned URLs"));
    }
} else {
    // Method not allowed
    http_response_code(405);
    echo json_encode(array("success" => false, "message" => "Method not allowed"));
    exit();
}
?>
