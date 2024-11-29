const express = require('express');
const pool = require('./db'); // Your database connection pool
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const multer = require('multer');
require('dotenv').config(); // .env file needed

const app = express();
app.use(express.json());

// Configure multer
const storage = multer.memoryStorage(); // Store files in memory as Buffer
/*const upload = multer({ storage: storage });
const upload = multer({
    limits: { fileSize: 10 * 1024 * 1024 }, // Set limit to 10MB
});*/
const upload = multer({
  storage: storage,
  limits: { fileSize: 100 * 1024 * 1024 }, // 10MB file size limit
});


// GET all keywords
app.get('/keywords', async (req, res) => {
    try {
        const conn = await pool.getConnection();
        const keywords = await conn.query("SELECT * FROM Keyword");
        res.json(keywords);
        conn.end();
    } catch (err) {
        res.status(500).send(err.toString());
    }
});

// GET keywords by userid
app.get('/keywords/:uid', async (req, res) => {
    try {
        const { uid } = req.params;
        const conn = await pool.getConnection();
        const keywords = await conn.query("SELECT * FROM User2Keyword WHERE U_ID = ?", [uid]);
        res.json(keywords);
        conn.end();
    } catch (err) {
        res.status(500).send(err.toString());
    }
});

// POST a User2Keyword entry
app.post('/keywords/:uid/:kid', async (req, res) => {
    const { uid, kid } = req.params;
    try {
        const conn = await pool.getConnection();
        await conn.query("INSERT INTO User2Keyword (U_ID, K_ID) VALUES (?, ?)", [uid, kid]);
        res.sendStatus(204); // No Content
        conn.end();
    } catch (err) {
        res.status(500).send(err.toString());
    }
});

// DELETE a User2Keyword entry
app.delete('/keywords/:uid/:kid', async (req, res) => {
    const { uid, kid } = req.params;
    try {
        const conn = await pool.getConnection();
        await conn.query("DELETE FROM User2Keyword WHERE U_ID = ? AND K_ID = ?", [uid, kid]);
        res.sendStatus(204); // No Content
        conn.end();
    } catch (err) {
        res.status(500).send(err.toString());
    }
});


// POST a new keyword
app.post('/keywords', async (req, res) => {
    const { Levels, Keyword, Description } = req.body; // Assuming these fields are sent in the request body
    try {
        const conn = await pool.getConnection();
        const result = await conn.query("INSERT INTO Keyword (Levels, Keyword, Description) VALUES (?, ?, ?)", [Levels, Keyword, Description]);
        res.json({ id: result.insertId, Levels, Keyword, Description });
        conn.end();
    } catch (err) {
        res.status(500).send(err.toString());
    }
});

// PUT (Update) an existing keyword
app.put('/keywords/:id', async (req, res) => {
    const { id } = req.params;
    const { Levels, Keyword, Description } = req.body;
    try {
        const conn = await pool.getConnection();
        await conn.query("UPDATE Keyword SET Levels = ?, Keyword = ?, Description = ? WHERE K_ID = ?", [Levels, Keyword, Description, id]);
        res.sendStatus(204); // No Content
        conn.end();
    } catch (err) {
        res.status(500).send(err.toString());
    }
});

// DELETE a keyword
app.delete('/keywords/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const conn = await pool.getConnection();
        await conn.query("DELETE FROM Keyword WHERE K_ID = ?", [id]);
        res.sendStatus(204); // No Content
        conn.end();
    } catch (err) {
        res.status(500).send(err.toString());
    }
});

// fetch users
app.get('/fetchUsers', async (req, res) => {
    try {
        const conn = await pool.getConnection();
        const { uId, name, surname, keyword, reachability, email } = req.query;
        let query =    "SELECT CONCAT(u.Name, ' ', u.Surname) AS FullName, "
                        + 'u.Reachability, '
                        + "GROUP_CONCAT(DISTINCT k.Keyword SEPARATOR ', ') AS Keywords, "
                        + 'u.Email, '
                        + 'u.Picture, '
                        + 'u.Seniority, '
                        + 'u.Description, '
                        + 'u.U_ID, '
                        + "GROUP_CONCAT(DISTINCT tk.Token SEPARATOR ', ') AS Tokens "
                     + 'FROM User u '
                     + 'LEFT JOIN User2Keyword uk ON u.U_ID = uk.U_ID '
                     + 'LEFT JOIN Keyword k ON uk.K_ID = k.K_ID '
                     + 'LEFT JOIN Keyword2Topic kt ON k.K_ID = kt.K_ID '
                     + 'LEFT JOIN Topic t ON kt.T_ID = t.T_ID '
                     + 'LEFT JOIN Token tk ON tk.U_ID = u.U_ID '
                     + 'WHERE u.U_ID IN ('
                        + 'SELECT u2.U_ID '
                        + 'FROM User u2 '
                        + 'LEFT JOIN User2Keyword uk2 ON u2.U_ID = uk2.U_ID '
                        + 'LEFT JOIN Keyword k2 ON uk2.K_ID = k2.K_ID '
                        + 'WHERE 1 = 1';
        const params = [];

        // adding U_ID filtering
        if(uId !== undefined && uId.trim() !== '') {
                query += " AND u2.U_ID = ?";
                params.push(uId);
        }

        // adding name filtering
        if(name !== undefined && name.trim() !== '') {
                query += " AND u2.Name = ?";
                params.push(name);
        }

        // adding surname filtering
        if(surname !== undefined && surname.trim() !== '') {
                query += " AND u2.Surname = ?";
                params.push(surname);
        }

        // adding keyword filtering
        if (keyword !== undefined && keyword.trim() !== '') {
            query += " AND k2.Keyword = ?";
            params.push(keyword);
        }

        // adding reachability filtering
        if (reachability !== undefined && reachability.trim() !== '') {
                let reach = parseInt(reachability, 10);
                if(reach !== 2) {
                        query += " AND u2.Reachability IN (?, 2)";
                        params.push(reach);
                }
        }

        // adding email filter
        if(email !== undefined && email.trim() !== '') {
                query += " AND u2.Email = ?";
                params.push(email);
        }

        query +=       ')'
                     + ' GROUP BY u.U_ID, u.Name, u.Surname, u.Reachability';

        // Execute the query
        const users = await conn.query(query, params);
        res.json(users);
        conn.release();
    } catch (err) {
        console.error(err);
        res.status(500).send(err.toString());
    }
});

// fetch distinct user column
app.get('/toFetch/:fetch', async (req, res) => {
    try {
        const conn = await pool.getConnection();
        const { fetch } = req.params;
        const clFetch = fetch.replace("fetch=", "");

        // Preventing to fetch Password
        const validCols = ['U_ID', 'Name', 'Surname', 'Reachability', 'Email', 'Picture', 'Seniority', 'Description'];
        if(!validCols.includes(clFetch)) {
                res.status(400).send('Invalid Column Name');
        }

        const data = await conn.query(`SELECT DISTINCT \`${clFetch}\` FROM User`)
        res.json(data);
        conn.end();
    } catch (err) {
        res.status(500).send(err.toString());
    }
});

// fetch token from userId
app.get('/tokens/:id', async (req, res) => {
    try {
        const conn = await pool.getConnection();
        const { id } = req.params;
        const tokens = await conn.query("SELECT * FROM Token WHERE U_ID = ?", [id]);
        res.json(tokens);
        conn.end();
    } catch (err) {
        res.status(500).send(err.toString());
    }
});


//get 1 user
app.get('/users/:id', async (req, res) => {
    try {
        const conn = await pool.getConnection();
        const { id } = req.params;
        const users = await conn.query("SELECT U_ID, Name, Surname, Reachability, Email, Picture, Seniority, Description FROM User WHERE U_ID = ?", [id]);
        res.json(users);
        conn.end();
    } catch (err) {
        res.status(500).send(err.toString());
    }
});


// POST /login route for user authentication
app.post('/login', async (req, res) => {
    const { email, password } = req.body;
    console.log('Received email:', email);
    console.log('Received password:', password);

    if (!email || !password) {
        return res.status(400).json({ message: 'Email and password are required' });
    }

    try {
        const conn = await pool.getConnection();

        // Query to get the user by email
        const result = await conn.query("SELECT U_ID, Name, Surname, Reachability, Email, Password FROM User WHERE Email = ?", [email]);

        if (result.length === 0) {
            return res.status(400).json({ message: 'Invalid credentials' });
        }

        const user = result[0];  // Get the first (and only) user matching the email

        // Compare provided password with stored hashed password
        const isMatch = await bcrypt.compare(password, user.Password);

        if (!isMatch) {
            return res.status(400).json({ message: 'Invalid credentials' });
        }

        // Generate a JWT token (optional, to be used for authentication in subsequent requests)
        const token = jwt.sign({ userId: user.U_ID }, process.env.JWT_SECRET, { expiresIn: '1h' });
        // Exclude password from user object before sending response
        const { Password, ...userWithoutPassword } = user;
        // Send success response with user data (excluding password) and the token
        res.json({ user: userWithoutPassword, token });

        conn.release(); // Release the connection back to the pool
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
});

//Change Password
app.post('/change-password', async (req, res) => {
    const { email, oldPassword, newPassword } = req.body;

    if (!email || !oldPassword || !newPassword) {
        return res.status(400).json({ message: 'Email, old password, and new password are required' });
    }

    try {
        const conn = await pool.getConnection();

        // Query to get the user by email
        const result = await conn.query("SELECT U_ID, Password FROM User WHERE Email = ?", [email]);

        if (result.length === 0) {
            conn.release();
            return res.status(400).json({ message: 'Invalid email or password' });
        }

        const user = result[0]; // Get the first (and only) user matching the email

        // Compare provided oldPassword with stored hashed password
        const isMatch = await bcrypt.compare(oldPassword, user.Password);

        if (!isMatch) {
            conn.release();
            return res.status(400).json({ message: 'Incorrect old password' });
        }

        // Hash the new password
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(newPassword, salt);

        // Update the password in the database
        await conn.query("UPDATE User SET Password = ? WHERE U_ID = ?", [hashedPassword, user.U_ID]);

        conn.release(); // Release the connection back to the pool
        res.status(200).json({ message: 'Password updated successfully' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
});

// POST (Create) a new user
app.post('/users', upload.single('Picture'), async (req, res) => {
    const { Name, Surname, Reachability, Email, Password } = req.body;
    // Get the picture from the request file
    const Picture = req.file ? req.file.buffer : null;

    try {
        const hashedPassword = await bcrypt.hash(Password, 10);
        const conn = await pool.getConnection();

        // Insert into database, allowing Picture to be null
        const result = await conn.query(
            "INSERT INTO User (Name, Surname, Reachability, Email, Password, Picture) VALUES (?, ?, ?, ?, ?, ?)",
            [Name, Surname, Reachability, Email, hashedPassword, Picture]
        );

        res.json({ id: result.insertId, Name, Surname, Reachability, Email, Picture });
        conn.release(); // Release the connection back to the pool
    } catch (err) {
        res.status(500).send(err.toString());
    }
});

// POST (Update) token
app.post('/updateToken', async (req, res) => {
    const { token, uId } = req.body;

    if (token === undefined || uId === undefined) {
        return res.status(400).json({ message: 'Token and U_ID required' });
    }

    const insertQ = 'INSERT INTO Token (Token, U_ID, LastUpdated) '
        + 'VALUES (?, ?, NOW()) '
        + 'ON DUPLICATE KEY UPDATE LastUpdated = NOW()';

    let conn;

    try {
        conn = await pool.getConnection();

        // Insert or update the token
        await conn.query(insertQ, [token, uId]); // No callback is needed with promises
        return res.status(200).json({ message: 'Token updated successfully' });

    } catch (error) {
        console.error('Database error:', error);
        return res.status(500).json({ message: 'Error updating token', error: error.message || error });

    } finally {
        if (conn) {
            try {
                conn.release(); // Safely release the connection
            } catch (releaseError) {
                console.error('Error releasing connection:', releaseError);
            }
        }
    }
});

// PUT (Update) an existing user (excluding password)
app.put('/users/:id', upload.single('Picture'), async (req, res) => {
    const { id } = req.params;
    const { Name, Surname, Reachability, Email, Seniority, Description } = req.body;
    const Picture = req.file ? req.file.buffer : null; // Handle the picture separately

    // Ensure required fields are provided
    if (!Name || !Surname || !Email) {
        return res.status(400).send("Name, Surname, and Email are required.");
    }

    try {
        const conn = await pool.getConnection();

        // SQL query to update user data (excluding password)
        const result = await conn.query(
            `UPDATE User
            SET Name = ?, Surname = ?, Reachability = ?, Email = ?,
                Picture = COALESCE(?, Picture), Seniority = ?, Description = ?
            WHERE U_ID = ?`,
            [Name, Surname, Reachability, Email, Picture, Seniority, Description, id]
        );

        // Check if any rows were affected
        if (result.affectedRows === 0) {
            res.status(404).send("User not found");
        } else {
            res.sendStatus(204); // No Content
        }

        conn.release(); // Release the connection back to the pool
    } catch (err) {
        console.error(err);
        res.status(500).send(err.toString());
    }
});

// DELETE a user
app.delete('/users/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const conn = await pool.getConnection();
        const result = await conn.query("DELETE FROM Users WHERE U_ID = ?", [id]);
        if (result.affectedRows === 0) {
            res.status(404).send("User not found");
        } else {
            res.sendStatus(204);
        }
        conn.end();
    } catch (err) {
        res.status(500).send(err.toString());
    }
});

// DELETE a token from a user
app.delete('/deleteToken', async (req, res) => {
    const { token, uId } = req.body;
    if (!token || !uId) {
        return res.status(400).send('Token or user ID is missing');
    }

    try {
        const conn = await pool.getConnection();
        const result = await conn.query("DELETE FROM Token WHERE Token = ? AND U_ID = ?", [token, uId]);
        if (result.affectedRows === 0) {
            res.status(404).send("User and/or token not found");
        } else {
            res.sendStatus(204);
        }
        conn.end();
    } catch (err) {
        res.status(500).send(err.toString());
    }
});

// Start the server
app.listen(3000,'0.0.0.0', () => {
    console.log('API is running on http://0.0.0.0:3000');
});
