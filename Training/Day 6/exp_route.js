const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.send('Welcome to the Home Page!');
});

app.get('/about', (req, res) => {
  res.send('This is the About Page.');
});

app.post('/submit', (req, res) => {
  res.send('Data received via POST');
});

app.listen(3000, () => {
  console.log('Server is running on http://localhost:3000');
});