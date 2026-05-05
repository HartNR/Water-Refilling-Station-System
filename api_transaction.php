<?php
header("Content-Type: application/json");
require 'db_connect.php';

$rawData = file_get_contents("php://input");
$data = json_decode($rawData, true);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($data['customer_name']) && isset($data['total_amount'])) {
        try {
            $pdo->beginTransaction();

            // FIXED: Using plural 'customers' table
            $sqlCustomer = "INSERT INTO customers (CustomerName) VALUES (:name)";
            $stmtCustomer = $pdo->prepare($sqlCustomer);
            $stmtCustomer->bindParam(':name', $data['customer_name']);
            $stmtCustomer->execute();
            
            $customerId = $pdo->lastInsertId();

            // FIXED: Using plural 'transactions' table
            $sqlTransaction = "INSERT INTO transactions (UserID, CustomerID, ServiceType, Quantity, TotalAmount) 
                               VALUES (1, :custId, :type, :qty, :amount)";
            
            $stmtTrans = $pdo->prepare($sqlTransaction);
            $stmtTrans->bindParam(':custId', $customerId);
            $stmtTrans->bindParam(':type', $data['service_type']);
            $stmtTrans->bindParam(':qty', $data['quantity']);
            $stmtTrans->bindParam(':amount', $data['total_amount']);
            $stmtTrans->execute();

            $pdo->commit();

            echo json_encode(["status" => "success", "message" => "Transaction recorded successfully!"]);
        } catch (Exception $e) {
            $pdo->rollBack(); 
            echo json_encode(["status" => "error", "message" => "Failed to record transaction: " . $e->getMessage()]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Missing data parameters."]);
    }
}
?>