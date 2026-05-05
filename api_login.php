<?php
header("Content-Type: application/json");

// Suppress normal PHP errors from breaking our JSON response
error_reporting(E_ALL);
ini_set('display_errors', 0);

try {
    require 'db_connect.php'; 
    
    $rawData = file_get_contents("php://input");
    $data = json_decode($rawData, true);
    
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $username = $data['username'] ?? '';
        $password = $data['password'] ?? '';
        
        $stmt = $pdo->prepare("SELECT * FROM users WHERE Username = :username AND Password = :password");
        $stmt->bindParam(':username', $username);
        $stmt->bindParam(':password', $password);
        $stmt->execute();
        
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($user) {
            echo json_encode([
                "status" => "success", 
                "message" => "Login successful",
                "role" => $user['Role']
            ]);
        } else {
            // --- DEBUGGING MAGIC ---
            // If it fails, let's look at what is actually inside the database
            $countStmt = $pdo->query("SELECT COUNT(*) FROM users");
            $totalUsers = $countStmt->fetchColumn();
            
            $debugStmt = $pdo->query("SELECT Username, Password FROM users LIMIT 1");
            $firstUser = $debugStmt->fetch(PDO::FETCH_ASSOC);
            
            $dbUser = $firstUser ? $firstUser['Username'] : 'None';
            $dbPass = $firstUser ? $firstUser['Password'] : 'None';
            
            $errorMsg = "Failed! \n" .
                        "You typed: Username='$username', Password='$password' \n" .
                        "Total users in DB: $totalUsers \n" .
                        "1st user in DB: Username='$dbUser', Password='$dbPass'";
            
            echo json_encode([
                "status" => "error", 
                "message" => $errorMsg
            ]);
        }
    }
} catch (Exception $e) {
    echo json_encode([
        "status" => "error", 
        "message" => "System Error: " . $e->getMessage()
    ]);
}
?>