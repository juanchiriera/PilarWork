import mongoose, {Schema} from "mongoose";

const ReservaSchema = new Schema({
    personas: [{
        required: true,
        type: String,
    }],
    fechaInicio: {
        required: true,
        type: Date,
    },
    fechaFin: {
        required: true,
        type: Date,
    },
    elementos: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Elemento',
    }],
    clientes: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Cliente',
    },
});

// Add a virtual field 'id' that gets the value from '_id'
ReservaSchema.virtual('id').get(function () {
    return this._id.toHexString();
});

// Ensure virtual fields are serialized
ReservaSchema.set('toJSON', {
    virtuals: true,
});

export default mongoose.model('Reserva', ReservaSchema);