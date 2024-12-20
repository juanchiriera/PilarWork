const mongoose = require('mongoose');
const espacios = require('./Espacio.js');

const Elemento = new mongoose.Schema({
    name: {
        required: true,
        type: String
    },
    quantity: {
        required: true,
        type: Number
    },
    available: {
        required: true,
        type: Boolean
    },
})

module.exports = espacios.discriminator('elementos', Elemento)