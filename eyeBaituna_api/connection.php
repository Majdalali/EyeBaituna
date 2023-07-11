<?php
$servername = "localhost";
$username = "id21023730_db_eyebaitunausername";
$password = "Eyebaituna1@";
$dbname = "id21023730_db_eyebaituna";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

?>

