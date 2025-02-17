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

// Add a virtual field 'id' that gets the value from '_id'
EspacioSchema.virtual('id').get(function () {
    return this._id.toHexString();
});

// Ensure virtual fields are serialized
EspacioSchema.set('toJSON', {
    virtuals: true,
});

export default mongoose.model('Espacio', EspacioSchema);