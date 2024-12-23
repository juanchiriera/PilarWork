import { Schema } from 'mongoose';

const Elemento = new Schema({
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

export default Elemento