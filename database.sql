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
    ProductID INT,
    FOREIGN KEY (ProductID) REFERENCES products(ProductID)
);

-- 5. CONTAINER INVENTORY Entity
CREATE TABLE container_inventory (
    ContainerID VARCHAR(50) PRIMARY KEY, -- String for barcode/QR
    ContainerType VARCHAR(50) NOT NULL,
    Capacity INT,
    Status ENUM('Available', 'Borrowed', 'Returned') DEFAULT 'Available'
);

-- 6. TRANSACTION Entity (Central Hub)
CREATE TABLE transactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    CustomerID INT,
    Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    ServiceType ENUM('Walk-in', 'Delivery') NOT NULL,
    Quantity INT NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (UserID) REFERENCES users(UserID),
    FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID)
);

-- 7. BORROWED CONTAINER Entity (Tracks Relationship)
CREATE TABLE borrowed_containers (
    BorrowID INT AUTO_INCREMENT PRIMARY KEY,
    TransactionID INT,
    ContainerID VARCHAR(50),
    BorrowDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    ReturnDate DATETIME NULL,
    FOREIGN KEY (TransactionID) REFERENCES transactions(TransactionID),
    FOREIGN KEY (ContainerID) REFERENCES container_inventory(ContainerID)
);

INSERT INTO users (Username, Password, Role) VALUES ('admin', 'admin123', 'Admin');