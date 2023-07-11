<?php
include '../connection.php';

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// Retrieve the email from the request
$email = $_POST['email'];

// Prepare the SQL statement with a parameterized query to prevent SQL injection
$sqlQuery = "SELECT COUNT(*) as emailCount FROM users WHERE email = ?";

// Prepare and bind the statement
$stmt = $conn->prepare($sqlQuery);
$stmt->bind_param("s", $email);
$stmt->execute();

// Fetch the result
$result = $stmt->get_result();
$row = $result->fetch_assoc();

// Check if the email count is greater than zero
$emailFound = ($row['emailCount'] > 0);

// Prepare the response as JSON
$response = array("emailFound" => $emailFound);
echo json_encode($response);

// Close the statement and database connection
$stmt->close();
$conn->close();
?>
