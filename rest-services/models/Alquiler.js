import mongoose, { Schema } from 'mongoose';

const AlquilerSchema = new Schema({
    cantidad: {
        type: Number
    },
    reservas: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Reservas',
    }],
    precios: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Precio',
    }],
})

AlquilerSchema.virtual('id').get(function () {
    return this._id.toHexString();
});

AlquilerSchema.set('toJSON', {
    virtuals: true,
});

export default mongoose.model('Alquiler', AlquilerSchema);