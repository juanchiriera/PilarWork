import mongoose, { Schema } from 'mongoose';

const PrecioSchema = new Schema({
    medida: {
        medida: true,
        type: String,
    },
    valor: {
        required: true,
        type: Number,
    },
    espacios: [{
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Espacio',
        }],
});

// Add a virtual field 'id' that gets the value from '_id'
PrecioSchema.virtual('id').get(function () {
    return this._id.toHexString();
});

// Ensure virtual fields are serialized
PrecioSchema.set('toJSON', {
    virtuals: true,
});

export default mongoose.model('Precio', PrecioSchema);