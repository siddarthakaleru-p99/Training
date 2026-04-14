const http = require('http');

const server = http.createServer((req, res) => {
    const url = req.url;
    const method = req.method;

    
    if (url === '/' && method === 'GET') {
        res.writeHead(200, {'Content-Type': 'text/plain'});
        res.end('Welcome to the homepage!\n');
    }
    else if (url === '/about' && method === 'GET') {
        res.writeHead(200, {'Content-Type': 'text/plain'});
        res.end('This is the about page.\n');
    }
    else {
        res.writeHead(404);
        res.end('Page not found');
    }
});

server.listen(3000, () => console.log('Server running'));