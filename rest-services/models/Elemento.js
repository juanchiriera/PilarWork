import mongoose, { Schema } from 'mongoose';

const ElementoSchema = new Schema({
    name: {
        required: true,
        type: String,
    },
    quantity: {
        required: true,
        type: Number,
    },
    available: {
        required: true,
        type: Boolean,
    },
});

export default mongoose.model('Elemento', ElementoSchema);