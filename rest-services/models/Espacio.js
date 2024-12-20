const mongoose = require('mongoose');

const Espacio = new mongoose.Schema({
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

module.exports = mongoose.model('Espacio', Espacio)