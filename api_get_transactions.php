<?php
header("Content-Type: application/json");
require 'db_connect.php'; 

try {
    // FIXED: Using plural 'transactions' and 'customers' tables
    $sql = "SELECT 
                t.TransactionID, 
                c.CustomerName, 
                t.ServiceType, 
                t.TotalAmount, 
                t.Date 
            FROM transactions t
            LEFT JOIN customers c ON t.CustomerID = c.CustomerID
            ORDER BY t.Date DESC 
            LIMIT 10"; 

    $stmt = $pdo->query($sql);
    $transactions = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        "status" => "success", 
        "data" => $transactions
    ]);

} catch (Exception $e) {
    echo json_encode([
        "status" => "error", 
        "message" => "Could not fetch data: " . $e->getMessage()
    ]);
}
?>