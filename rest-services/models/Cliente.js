const mongoose = require('mongoose');

const clientes = new mongoose.Schema({
    name: {
        required: true,
        type: String
    },
    surname: {
        required: true,
        type: String
    },
    mail: {
        required: true,
        type: String
    },
    phone: {
        required: true,
        type: String
    },
})

module.exports = mongoose.model('clientes', clientes)