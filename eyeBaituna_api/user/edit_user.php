<?php
include '../connection.php';

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$id = $_POST['id'];
$newUsername = $_POST['username'];
$newEmail = $_POST['email'];
$newPinCode = $_POST['pincode'];


$sqlQuery = "UPDATE users SET username = ?, email = ?, pincode = ? WHERE id = ?";
$stmt = $conn->prepare($sqlQuery);
$stmt->bind_param("ssii", $newUsername, $newEmail, $newPinCode, $id);
$stmt->execute();

if ($stmt->affected_rows > 0) {
    echo json_encode(array("success" => true, "message" => "User information updated successfully"));
} else {
    echo json_encode(array("success" => false, "message" => "Failed to update user information"));
}

?>
