require('dotenv').config();
const express = require('express');
const app = express ();
const mongoose = require('mongoose');
const mongoString = process.env.DATABASE_URL
app.use(express.json());

//Registrar rutas
const espaciosRoutes = require('./routes/espacios');
const clienteRoutes = require('./routes/clientes');
const elementosRoutes = require('./routes/elementos');

app.use('/api', espaciosRoutes)
app.use('/api', clienteRoutes)
app.use('/api', elementosRoutes)

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
