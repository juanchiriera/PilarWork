import { mongoose, Schema } from 'mongoose';
import Elemento from './Elemento.js';

const Espacio = Schema({
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
    elementos: {
        required: false,
        type: [Elemento]
    }
})

export default mongoose.model('Espacio', Espacio)

export { Espacio as Espacio }