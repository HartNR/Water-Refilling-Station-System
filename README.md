# SmartWater Pro - Water Refilling Station Management System

A web-based management system for water refilling stations to manage transactions, inventory, customers, and water supply tracking.

---

##  Table of Contents

- [Overview](#overview)
- [Features](#features)
- [System Architecture](#system-architecture)
- [Installation & Setup](#installation--setup)
- [How It Works](#how-it-works)
- [Project Structure](#project-structure)
- [API Endpoints](#api-endpoints)
- [Database Schema](#database-schema)
- [Known Issues](#known-issues)
- [Future Improvements](#future-improvements)
- [Troubleshooting](#troubleshooting)

---

##  Overview

SmartWater Pro is a single-page application (SPA) designed for water refilling stations to:
- Record and track water delivery transactions
- Manage customer information
- Track water supply inventory
- Monitor borrowed containers
- Manage staff with role-based access (Admin, Staff, Delivery)

**Tech Stack:**
- **Frontend:** HTML5, CSS3, JavaScript (Vanilla)
- **Backend:** PHP 7+
- **Database:** MySQL 5.7+
- **Server:** Apache/Nginx with PHP support

---

## Features

### Dashboard
- Real-time sales overview
- Water supply status
- Borrowed containers tracking
- Recent transaction history (last 10 transactions)

### Transaction Management
- Record new sales transactions
- Support for Walk-in and Delivery service types
- Customer lookup and creation
- Quantity tracking
- Amount calculation

### Customer Management
- Customer database with contact information
- Address tracking
- Associated transaction history

### Inventory Management
- Container status tracking (Available, Borrowed, Returned)
- Barcode/QR code support for containers
- Container type and capacity management

### User Management
- Role-based access control (Admin, Staff, Delivery)
- Authentication and login system
- User session management

---

##  System Architecture

```
┌─────────────────────────────────────────┐
│       Frontend (HTML/CSS/JS)            │
│   - Login Interface                     │
│   - Dashboard                           │
│   - Transaction Form                    │
│   - Inventory & Customer Views          │
└────────────┬────────────────────────────┘
             │ (AJAX/Fetch API)
             ↓
┌─────────────────────────────────────────┐
│     Backend API Layer (PHP)             │
│   - api_login.php                       │
│   - api_transaction.php                 │
│   - api_get_transactions.php            │
│   - db_connect.php (DB Connection)      │
└────────────┬────────────────────────────┘
             │ (PDO/SQL Queries)
             ↓
┌─────────────────────────────────────────┐
│     MySQL Database                      │
│   - users, customers, transactions      │
│   - products, water_supply              │
│   - containers, borrowed_containers     │
└─────────────────────────────────────────┘
```

---

##  Installation & Setup

### Prerequisites
- PHP 7.0 or higher
- MySQL 5.7 or higher
- Apache/Nginx web server with PHP support
- Modern web browser

### Step 1: Database Setup

1. Open your MySQL client (phpMyAdmin, MySQL Workbench, or command line)
2. Import the database schema:
   ```bash
   mysql -u admin -p < database.sql
   ```
3. Or manually copy-paste the SQL from `database.sql` into your MySQL client

4. Verify the default user:
   - **Username:** `admin`
   - **Password:** `admin123`

### Step 2: Configure Database Connection

Edit `db_connect.php` and update the following credentials if needed:

```php
$host = '127.0.0.1';        // Your MySQL host
$port = '3306';             // Your MySQL port
$dbname = 'smartwaterstation'; // Database name
$username = 'admin';        // MySQL username
$password = 'admin123';     // MySQL password
```

### Step 3: Deploy Files

1. Copy all project files to your web server's root directory:
   - **Apache:** `/var/www/html/` or `C:\xampp\htdocs\`
   - **Nginx:** `/var/www/html/` or similar

2. Ensure proper file permissions:
   ```bash
   chmod 644 *.php *.html *.css *.js
   chmod 755 app/
   ```

### Step 4: Start Services

1. Start MySQL service
2. Start Apache/Nginx/PHP
3. Open browser and navigate to: `http://localhost/Water%20Refilling%20Station%20System/`

### Step 5: Login

Use the default credentials:
- **Username:** `admin`
- **Password:** `admin123`

---

## 💡 How It Works

### User Flow

1. **Login**
   - User enters credentials on the login screen
   - System validates against the `users` table
   - On success, user is authenticated and directed to dashboard

2. **Dashboard**
   - Displays today's sales summary
   - Shows water supply status
   - Lists recent transactions (last 10)
   - Auto-refreshes when navigated to

3. **Recording a Transaction**
   - User clicks "Transactions" in the sidebar
   - Enters customer name, service type, quantity, and amount
   - System creates new customer (if not exists) and transaction record
   - Confirmation message displayed

4. **Viewing Transaction History**
   - Automatically loaded and displayed in dashboard
   - Shows Transaction ID, Customer Name, Service Type, Amount, and Date
   - Limited to 10 most recent transactions

### Data Flow

```
User Input (Form)
    ↓
JavaScript validation
    ↓
AJAX POST request to API
    ↓
PHP processes request
    ↓
PDO executes SQL (with transaction control)
    ↓
Response returned as JSON
    ↓
JavaScript updates DOM
    ↓
User feedback (success/error message)
```

---

## 📁 Project Structure

```
Water Refilling Station System/
├── index.html                  # Main HTML file (SPA)
├── style.css                   # Styling and responsive design
├── script.js                   # Frontend logic and AJAX calls
├── db_connect.php              # Database connection configuration
├── api_login.php               # Login authentication API
├── api_transaction.php         # Record transaction API
├── api_get_transactions.php    # Fetch recent transactions API
├── database.sql                # Database schema and sample data
├── app/                        # Placeholder folder for future modules
└── README.md                   # This file
```

---

## 🔌 API Endpoints

### 1. Login API
**Endpoint:** `POST /api_login.php`

**Request Body:**
```json
{
  "username": "admin",
  "password": "admin123"
}
```

**Response (Success):**
```json
{
  "status": "success",
  "message": "Login successful",
  "role": "Admin"
}
```

**Response (Error):**
```json
{
  "status": "error",
  "message": "Failed! You typed: Username='admin', Password='wrongpass'..."
}
```

---

### 2. Record Transaction API
**Endpoint:** `POST /api_transaction.php`

**Request Body:**
```json
{
  "customer_name": "John Doe",
  "service_type": "Walk-in",
  "quantity": 5,
  "total_amount": 150.00
}
```

**Response (Success):**
```json
{
  "status": "success",
  "message": "Transaction recorded successfully!"
}
```

**Response (Error):**
```json
{
  "status": "error",
  "message": "Missing data parameters."
}
```

---

### 3. Get Transactions API
**Endpoint:** `GET /api_get_transactions.php`

**Response (Success):**
```json
{
  "status": "success",
  "data": [
    {
      "TransactionID": 1,
      "CustomerName": "John Doe",
      "ServiceType": "Walk-in",
      "TotalAmount": "150.00",
      "Date": "2026-05-05 10:30:45"
    },
    ...
  ]
}
```

---

## 🗄️ Database Schema

### Tables

1. **users** - System users with roles
   - UserID, Username, Password, Role

2. **customers** - Customer information
   - CustomerID, CustomerName, Address, ContactNumber

3. **transactions** - Sales transactions (Central Hub)
   - TransactionID, UserID, CustomerID, Date, ServiceType, Quantity, TotalAmount

4. **products** - Product catalog
   - ProductID, ProductName, BasePrice

5. **water_supply** - Water inventory tracking
   - SupplyID, AvailableStock, ProductionDate, ProductID

6. **container_inventory** - Container management
   - ContainerID, ContainerType, Capacity, Status

7. **borrowed_containers** - Container borrowing records
   - BorrowID, TransactionID, ContainerID, BorrowDate, ReturnDate

---

## ⚠️ Known Issues

### 🔴 Critical Security Issues

1. **Hardcoded Credentials in PHP Files**
   - Database credentials stored in plaintext in `db_connect.php`
   - Should use environment variables or configuration files

2. **Debugging Output in Login API**
   - `api_login.php` reveals database structure and sample credentials on failed login
   - Exposes first user's credentials in error messages
   - This is intentional for debugging but **MUST be removed in production**

3. **Unencrypted Passwords**
   - User passwords stored in plaintext in database
   - Should use bcrypt or similar hashing algorithms
   - Current logic: `SELECT * FROM users WHERE Username = :username AND Password = :password` is vulnerable

4. **Hardcoded UserID**
   - `api_transaction.php` uses hardcoded `UserID = 1` for all transactions
   - Should use authenticated user's ID from session

### 🟡 Functional Issues

5. **Login Bypass**
   - `script.js` automatically calls `showApp()` on page load
   - Login screen is bypassed, authentication is not enforced
   - Comment out `showApp();` to enable login requirement

6. **No Input Validation**
   - Minimal server-side validation
   - SQL Injection risks if not properly parameterized (currently using prepared statements, which is good)
   - No input sanitization for HTML/XSS attacks

7. **No Duplicate Customer Prevention**
   - Creating a transaction always inserts a new customer
   - Leads to duplicate customer records with same name
   - No unique constraints on CustomerName

8. **Empty Container (Container Inventory) Tracking**
   - Container management tables are created but not integrated into UI
   - Borrowed containers feature not fully implemented in frontend

9. **No Session Management**
   - Uses `sessionStorage` only (frontend-only)
   - No server-side session tracking
   - No timeout/expiration logic

10. **No Error Logging**
    - Errors are returned in JSON but not logged to a file
    - Makes debugging and monitoring difficult

### 🟠 UI/UX Issues

11. **Static Dashboard Data**
    - Water supply (850 Gal) is hardcoded in HTML
    - Borrowed containers count (24) is hardcoded
    - Not updated from database

12. **Unused App Folder**
    - Empty `app/` folder present in project
    - Suggests incomplete modularization

13. **Limited Transaction History**
    - Only shows last 10 transactions
    - No pagination or filtering options

---

## 🔮 Future Improvements

1. **Security Enhancements**
   - Implement password hashing (bcrypt)
   - Move credentials to environment variables
   - Add CSRF token protection
   - Implement CORS headers
   - Remove debug output from APIs
   - Add rate limiting on login attempts

2. **Feature Development**
   - Implement container borrowing/returning workflow
   - Add inventory management UI
   - Real-time water supply updates
   - Customer profile management
   - Transaction filtering and search
   - Generate reports (daily, weekly, monthly)
   - Receipt printing functionality

3. **Backend Improvements**
   - Implement proper session management
   - Add database transaction logging
   - Create audit trail for all changes
   - Add input validation library
   - Implement error logging

4. **Frontend Improvements**
   - Add pagination for transactions
   - Implement real-time updates (WebSockets)
   - Add data visualization (charts/graphs)
   - Responsive mobile design
   - Dark mode support
   - Export to CSV/PDF functionality

5. **Database**
   - Add more constraints and indexes
   - Implement data retention policies
   - Add backup scripts
   - Create stored procedures for complex queries

6. **Testing**
   - Add unit tests
   - Add integration tests
   - Add API testing (Postman)
   - Security testing/penetration testing

---

## 🆘 Troubleshooting

### Issue: "Database Connection Failed"

**Solution:**
1. Verify MySQL is running: `sudo systemctl status mysql`
2. Check credentials in `db_connect.php` match your MySQL setup
3. Ensure database exists: `SHOW DATABASES;`
4. Verify user permissions: `GRANT ALL PRIVILEGES ON smartwaterstation.* TO 'admin'@'localhost';`

### Issue: Login fails with debugging info displayed

**Solution:**
1. This is normal if debugging is active
2. Verify username/password are correct (default: admin/admin123)
3. Check that `users` table has been populated by `database.sql`
4. View raw database: 
   ```sql
   SELECT * FROM users;
   ```

### Issue: Transaction not being recorded

**Solution:**
1. Verify all required fields are filled (customer name, service type, quantity, amount)
2. Check browser console (F12) for JavaScript errors
3. Check PHP error logs
4. Verify `customers` and `transactions` tables exist
5. Test API directly with curl:
   ```bash
   curl -X POST http://localhost/api_transaction.php \
     -H "Content-Type: application/json" \
     -d '{"customer_name":"Test","service_type":"Walk-in","quantity":1,"total_amount":50}'
   ```

### Issue: Transactions not displaying in dashboard

**Solution:**
1. Refresh page (F5) to force data reload
2. Click "Dashboard" in sidebar to trigger `loadRecentTransactions()`
3. Check browser network tab for API response errors
4. Verify `transactions` table has data:
   ```sql
   SELECT * FROM transactions;
   ```

### Issue: "Server Error: Make sure your Database is connected"

**Solution:**
1. Database is not running or not accessible
2. Check database credentials in `db_connect.php`
3. Verify MySQL port (default: 3306)
4. Test connection manually:
   ```php
   php db_connect.php
   ```

---

## 📞 Support Notes

- **Default Credentials:** Username: `admin` | Password: `admin123`
- **Database Name:** `smartwaterstation`
- **Database Host:** `127.0.0.1` (localhost)
- **Default Port:** `3306`

---

## 📝 License

This project is provided as-is. Modify and distribute as needed for your water refilling station operations.

---

**Last Updated:** May 5, 2026  
**Version:** 1.0  
**Status:** Development (Not Production Ready)
