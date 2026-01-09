const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const { v4: uuidv4 } = require('uuid');

const app = express();
const port = 3000;

// Middleware
app.use(express.json());

// Database setup
const db = new sqlite3.Database(':memory:'); // In-memory SQLite database
db.serialize(() => {
    // Create tables
    db.run(`
    CREATE TABLE Expense (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      type TEXT NOT NULL,
      amount REAL NOT NULL,
      date REAL NOT NULL,                -- Date stored as milliseconds since Unix epoch
      locationLatitude REAL,
      locationLongitude REAL,
      locationName TEXT
    )
  `);
});

// Helper: Validate ExpenseType
const validExpenseTypes = ['food', 'transport', 'entertainment', 'shopping', 'utilities', 'other'];

const isValidExpenseType = (type) => validExpenseTypes.includes(type);

// Routes
// 1. Get all expenses
app.get('/expenses', (req, res) => {
    db.all('SELECT * FROM Expense', (err, rows) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(rows);
    });
});

// 2. Get a single expense by ID
app.get('/expenses/:id', (req, res) => {
    const { id } = req.params;
    db.get('SELECT * FROM Expense WHERE id = ?', [id], (err, row) => {
        if (err) return res.status(500).json({ error: err.message });
        if (!row) return res.status(404).json({ error: 'Expense not found' });
        res.json(row);
    });
});

// 3. Create a new expense
app.post('/expenses', (req, res) => {
    const { title, type, amount, date, locationInfo } = req.body;

    // Validate inputs
    if (!title || !isValidExpenseType(type) || !amount || !date) {
        return res.status(400).json({ error: 'Invalid input' });
    }

    const timestamp = new Date(date).getTime(); // Convert date to milliseconds

    const id = uuidv4();
    const locationLatitude = locationInfo?.latitude || null;
    const locationLongitude = locationInfo?.longitude || null;
    const locationName = locationInfo?.name || null;

    db.run(
        `INSERT INTO Expense (id, title, type, amount, date, locationLatitude, locationLongitude, locationName)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
        [id, title, type, amount, timestamp, locationLatitude, locationLongitude, locationName],
        (err) => {
            if (err) return res.status(500).json({ error: err.message });
            res.status(201).json({ id, title, type, amount, date: timestamp, locationInfo });
        }
    );
});

// 4. Update an expense
app.put('/expenses/:id', (req, res) => {
    const { id } = req.params;
    const { title, type, amount, date, locationInfo } = req.body;

    if (!title || !isValidExpenseType(type) || !amount || !date) {
        return res.status(400).json({ error: 'Invalid input' });
    }

    const timestamp = new Date(date).getTime(); // Convert date to milliseconds

    const locationLatitude = locationInfo?.latitude || null;
    const locationLongitude = locationInfo?.longitude || null;
    const locationName = locationInfo?.name || null;

    db.run(
        `UPDATE Expense SET title = ?, type = ?, amount = ?, date = ?, locationLatitude = ?, locationLongitude = ?, locationName = ?
     WHERE id = ?`,
        [title, type, amount, timestamp, locationLatitude, locationLongitude, locationName, id],
        function (err) {
            if (err) return res.status(500).json({ error: err.message });
            if (this.changes === 0) return res.status(404).json({ error: 'Expense not found' });
            res.json({ id, title, type, amount, date: timestamp, locationInfo });
        }
    );
});

// 5. Delete an expense
app.delete('/expenses/:id', (req, res) => {
    const { id } = req.params;
    db.run('DELETE FROM Expense WHERE id = ?', [id], function (err) {
        if (err) return res.status(500).json({ error: err.message });
        if (this.changes === 0) return res.status(404).json({ error: 'Expense not found' });
        res.status(204).send();
    });
});

// 6. Delete multiple expenses by IDs
app.delete('/expenses', (req, res) => {
    const { ids } = req.body;  // Expecting an array of IDs in the request body

    if (!Array.isArray(ids) || ids.length === 0) {
        return res.status(400).json({ error: 'Invalid input: Provide an array of IDs' });
    }

    // Prepare SQL query to delete multiple expenses
    const placeholders = ids.map(() => '?').join(', ');
    const query = `DELETE FROM Expense WHERE id IN (${placeholders})`;

    db.run(query, ids, function (err) {
        if (err) return res.status(500).json({ error: err.message });
        if (this.changes === 0) return res.status(404).json({ error: 'No expenses found to delete' });
        res.status(204).send();  // Successful deletion with no content returned
    });
});


// Start server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
