const http = require("http");
const { Pool } = require("pg");

const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

const server = http.createServer(async (req, res) => {
  try {
    const result = await pool.query("SELECT NOW()");
    res.writeHead(200, { "Content-Type": "text/plain" });
    res.end(`Hello from Node.js + Postgres!\nTime: ${result.rows[0].now}`);
  } catch (err) {
    res.writeHead(500);
    res.end(`DB Error: ${err.message}`);
  }
});

server.listen(3000, "0.0.0.0", () => {
  console.log("Server running on port 3000");
});
