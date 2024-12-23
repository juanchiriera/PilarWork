import mongoose, { Schema } from 'mongoose';

const EspacioSchema = new Schema({
    name: {
        required: true,
        type: String,
    },
    quantity: {
        required: true,
        type: Number,
    },
    available: {
        required: false,
        type: Boolean,
    },
    elementos: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Elemento',
    }],
});

export default mongoose.model('Espacio', EspacioSchema);