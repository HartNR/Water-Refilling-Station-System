document.addEventListener("DOMContentLoaded", () => {
    // --- 1. LOGIN & AUTHENTICATION LOGIC ---
    const loginOverlay = document.getElementById('loginOverlay');
    const appContainer = document.getElementById('appContainer');
    const loginForm = document.getElementById('loginForm');
    const logoutBtn = document.getElementById('logoutBtn');
    
    // Check if user is already logged in (via sessionStorage)
    // Temporarily disabled login - always show app
    showApp();

    loginForm.addEventListener('submit', (e) => {
        e.preventDefault();
        const user = document.getElementById('loginUsername').value;
        const pass = document.getElementById('loginPassword').value;
        const errorBox = document.getElementById('loginError');

        fetch('api_login.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ username: user, password: pass })
        })
        .then(res => res.text()) // Read as text first to catch any PHP database errors
        .then(text => {
            try {
                const data = JSON.parse(text); // Try to convert to JSON
                if(data.status === 'success') {
                    sessionStorage.setItem('isLoggedIn', 'true');
                    document.getElementById('loggedInUser').innerText = `👤 ${data.role} User`;
                    showApp();
                } else {
                    // Show the specific error message from the server (e.g., "Invalid credentials")
                    errorBox.innerText = data.message;
                    errorBox.style.display = 'block';
                }
            } catch (err) {
                // If it's not JSON, it means PHP threw a major error (like Database offline)
                errorBox.innerText = "Server Error: Make sure your Database is connected and running.";
                console.error("Raw Server Response:", text);
                errorBox.style.display = 'block';
            }
        })
        .catch(err => {
            errorBox.innerText = "Network Error: Could not connect to the server.";
            errorBox.style.display = 'block';
        });
    });

    logoutBtn.addEventListener('click', () => {
        sessionStorage.removeItem('isLoggedIn');
        loginOverlay.style.display = 'flex';
        appContainer.style.display = 'none';
        document.getElementById('loginForm').reset();
        document.getElementById('loginError').style.display = 'none'; // Hide error box on logout
    });

    function showApp() {
        loginOverlay.style.display = 'none';
        appContainer.style.display = 'flex';
        loadRecentTransactions(); // Load data once logged in
    }

    // --- 2. INITIALIZATION ---
    const dateOptions = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
    document.getElementById('currentDate').innerText = new Date().toLocaleDateString('en-US', dateOptions);

    // --- 3. NAVIGATION (SPA Logic) ---
    const navButtons = document.querySelectorAll('.nav-btn');
    const sections = document.querySelectorAll('.content-section');

    navButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            navButtons.forEach(b => b.classList.remove('active'));
            sections.forEach(s => {
                s.classList.remove('active');
                s.classList.add('hidden'); 
            });

            btn.classList.add('active');
            const targetId = btn.getAttribute('data-target');
            const targetSection = document.getElementById(targetId);
            
            targetSection.classList.remove('hidden');
            setTimeout(() => targetSection.classList.add('active'), 10);
            
            // Auto refresh data if dashboard is clicked
            if(targetId === 'dashboard') loadRecentTransactions();
        });
    });

    // --- 4. TRANSACTION FORM SUBMISSION ---
    const form = document.getElementById('transactionForm');
    form.addEventListener('submit', (e) => {
        e.preventDefault();
        
        // Gather data from inputs
        const payload = {
            customer_name: document.getElementById('customerName').value,
            service_type: document.getElementById('serviceType').value,
            quantity: document.getElementById('quantity').value,
            total_amount: document.getElementById('totalAmount').value
        };

        // Send to Database
        fetch('api_transaction.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        })
        .then(response => response.json())
        .then(data => {
            if(data.status === 'success') {
                alert("Transaction saved successfully!");
                form.reset(); // Clear form
                
                // AUTO-UPDATE: Click the dashboard button to switch views automatically
                document.getElementById('btnDashboard').click(); 
                // loadRecentTransactions() is automatically called by the click event above!
            } else {
                alert("Error: " + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert("Failed to connect to the server.");
        });
    });

    // --- 5. FETCH & DISPLAY TRANSACTIONS ---
    function loadRecentTransactions() {
        fetch('api_get_transactions.php')
            .then(response => response.json()) 
            .then(result => {
                if (result.status === 'success') {
                    const tableBody = document.getElementById('transactionTableBody');
                    tableBody.innerHTML = ''; 
                    
                    let totalSales = 0;

                    // If there are no transactions yet
                    if (result.data.length === 0) {
                        tableBody.innerHTML = '<tr><td colspan="5" style="text-align: center;">No transactions found.</td></tr>';
                    } else {
                        // Loop through data and build table rows
                        result.data.forEach(trx => {
                            totalSales += parseFloat(trx.TotalAmount || trx.total_amount || 0);

                            // Fallback handling in case of different DB column names
                            const id = trx.TransactionID || trx.id;
                            const name = trx.CustomerName || trx.customer_name || 'Walk-in';
                            const type = trx.ServiceType || trx.type || 'Walk-in';
                            const amount = parseFloat(trx.TotalAmount || trx.total_amount).toFixed(2);
                            const date = new Date(trx.Date || trx.date).toLocaleDateString();

                            tableBody.innerHTML += `
                                <tr>
                                    <td>#TRX-${id}</td>
                                    <td>${name}</td>
                                    <td>${type}</td>
                                    <td>₱ ${amount}</td>
                                    <td>${date}</td>
                                </tr>
                            `;
                        });
                    }

                    // Update the "Today's Sales" Metric Card dynamically
                    document.getElementById('statSales').innerText = `₱ ${totalSales.toFixed(2)}`;

                } else {
                    console.error("Error fetching data:", result.message);
                }
            })
            .catch(error => {
                console.error("Network error:", error);
            });
    }
});