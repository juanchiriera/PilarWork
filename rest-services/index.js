require('dotenv').config();
const routes = require('./routes/espacios');
const express = require('express');
const app = express ();
const mongoose = require('mongoose');
const mongoString = process.env.DATABASE_URL
app.use(express.json());
app.use('/api', routes)

mongoose.connect(mongoString);
const database = mongoose.connection

database.on('error', (error) => {
    console.log(error)
})

database.once('connected', () => {
    console.log('Database Connected');
})


app.get('/status', (request, response) => {
    const status = {
       'Status': 'Running'
    };
    
    response.send(status);
});

const port = process.env.PORT || 3000;


app.listen(port, () => {
    console.log("Server Listening on PORT:", port);
});
