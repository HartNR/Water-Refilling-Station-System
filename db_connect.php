<?php
$host = '127.0.0.1';
$port = '3306';
$dbname = 'smartwaterstation';
$username = 'admin'; // Change this to your DB username if not root
$password = 'admin123';     // Change this to your DB password if root has one

try {
    $dsn = "mysql:host=$host;port=$port;dbname=$dbname;charset=utf8mb4";
    $pdo = new PDO($dsn, $username, $password);
    // Set PDO error mode to exception
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(PDOException $e) {
    // Return a JSON formatted error so JavaScript can read it
    header("Content-Type: application/json");
    echo json_encode([
        "status" => "error",
        "message" => "Database Connection Failed. " . $e->getMessage()
    ]);
    exit(); // Stop running the rest of the code
}
?>