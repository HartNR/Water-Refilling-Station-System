-- Create Database
CREATE DATABASE IF NOT EXISTS smartwaterstation;
USE smartwaterstation;

-- 1. USER Entity
CREATE TABLE users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Role ENUM('Admin', 'Staff', 'Delivery') NOT NULL
);

-- 2. CUSTOMER Entity
CREATE TABLE customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Address VARCHAR(255),
    ContactNumber VARCHAR(20)
);

-- 3. PRODUCT Entity
CREATE TABLE products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    BasePrice DECIMAL(10, 2) NOT NULL
);

-- 4. WATER_SUPPLY Entity
CREATE TABLE water_supply (
    SupplyID INT AUTO_INCREMENT PRIMARY KEY,
    AvailableStock DECIMAL(10, 2) NOT NULL DEFAULT 0.00, -- in Liters/Gallons
    ProductionDate DATE,
    ProductID INT NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES products(ProductID) ON DELETE CASCADE
);

-- 5. CONTAINER INVENTORY Entity
CREATE TABLE container_inventory (
    ContainerID VARCHAR(50) PRIMARY KEY, -- String for barcode/QR
    ContainerType VARCHAR(50) NOT NULL,
    Capacity INT,
    Status ENUM('Available', 'Borrowed') DEFAULT 'Available'
);

-- 6. TRANSACTION Entity (Central Hub)
CREATE TABLE transactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    CustomerID INT NOT NULL,
    Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    DeliveryDate DATETIME,
    ServiceType ENUM('Walk-in', 'Delivery') NOT NULL,
    PaymentMethod VARCHAR(50),
    MethodAmount DECIMAL(10,2),
    ChangeAmount DECIMAL(10,2),
    Status ENUM('Pending', 'Completed', 'Cancelled') DEFAULT 'Pending',
    IsRush BOOLEAN DEFAULT FALSE,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (UserID) REFERENCES users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID) ON DELETE CASCADE
);

CREATE TABLE transaction_items (
    ItemID INT AUTO_INCREMENT PRIMARY KEY,
    TransactionID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UNIQUE (TransactionID, ProductID),
    FOREIGN KEY (TransactionID) REFERENCES transactions(TransactionID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES products(ProductID)
);

-- 7. BORROWED CONTAINER Entity (Tracks Relationship)
CREATE TABLE borrowed_containers (
    BorrowID INT AUTO_INCREMENT PRIMARY KEY,
    TransactionID INT NOT NULL,
    ContainerID VARCHAR(50) NOT NULL,
    BorrowDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    ReturnDate DATETIME NULL,
    FOREIGN KEY (TransactionID) REFERENCES transactions(TransactionID) ON DELETE CASCADE,
    FOREIGN KEY (ContainerID) REFERENCES container_inventory(ContainerID) ON DELETE CASCADE
);

-- Indexes for faster queries
CREATE INDEX idx_transaction_user ON transactions(UserID);
CREATE INDEX idx_transaction_customer ON transactions(CustomerID);

INSERT INTO users (Username, Password, Role) VALUES ('admin', 'admin123', 'Admin');
