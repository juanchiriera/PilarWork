import "dotenv/config.js"; 
import express, { json } from 'express';
import cors from 'cors';
const app = express ();
import mongoose from 'mongoose';
const mongoString = process.env.DATABASE_URL
const { connect, connection } = mongoose;
app.use(json());

const corsSetup = {
    origin: 'http://localhost:5173',
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization', 'Range'],
    exposedHeaders: ['Content-Range'],
};
app.use(cors(corsSetup));

//Registrar rutas
import espaciosRoutes from './routes/espacios.js';
import clienteRoutes from './routes/clientes.js';
import elementosRoutes from './routes/elementos.js';

app.use('/api', espaciosRoutes)
app.use('/api', clienteRoutes)
app.use('/api', elementosRoutes)

connect(mongoString);
const database = connection

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
