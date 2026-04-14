const express = require('express');
const app = express();

app.get('/api/data', (req, res) => {
    const data = {
        id: 1,
        name: "John Doe",
        status: "active"
    };
    res.json(data); 
});

app.listen(3000);
