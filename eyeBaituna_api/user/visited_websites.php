<?php
include '../connection.php';

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Fetch Visited Websites
    if (isset($_GET['user_id'])) {
        $user_id = $_GET['user_id'];

        $sqlQuery = "SELECT vw.link, vw.visit_time, c.category_name
                     FROM visited_websites vw
                     LEFT JOIN categories_table c ON vw.category_id = c.category_id
                     WHERE vw.user_id = ?";
        $stmt = $conn->prepare($sqlQuery);
        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result) {
            $visited_websites = array();
            while ($row = $result->fetch_assoc()) {
                $visited_websites[] = array(
                    "link" => $row['link'],
                    "visit_time" => $row['visit_time'],
                    "category_name" => $row['category_name']
                );
            }
            echo json_encode(array("success" => true, "visited_websites" => $visited_websites));
        } else {
            echo json_encode(array("success" => false, "message" => "Failed to fetch visited websites"));
        }
    } else {
        // Bad request - user ID parameter is missing
        http_response_code(400);
        echo json_encode(array("success" => false, "message" => "User ID parameter is missing"));
        exit();
    }
} else {
    // Method not allowed
    http_response_code(405);
    echo json_encode(array("success" => false, "message" => "Method not allowed"));
    exit();
}
?>
