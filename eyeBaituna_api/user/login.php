<?php
include '../connection.php';

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$email = $_POST['email'];
$password = $_POST['password'];

$sqlQuery = "SELECT * FROM users WHERE email = ?";
$stmt = $conn->prepare($sqlQuery);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $hashedPassword = $row['password'];

    if (password_verify($password, $hashedPassword)) {
        unset($row['password']); // Remove the password field from the response
        echo json_encode(array("success" => true, "userData" => $row));
    } else {
        echo json_encode(array("success" => false, "message" => "Invalid password"));
    }
} else {
    echo json_encode(array("success" => false, "message" => "Invalid email"));
}
?>
