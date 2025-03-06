import mongoose, {Schema} from "mongoose";
import Espacio from "./Espacio.js";

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
    titulo: {
        type: String,
        required: false
    },
    descripcion: {
        type: String,
        required: false
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

ReservaSchema.virtual('espacio');

// Custom method to populate 'espacio'
ReservaSchema.methods.populateEspacio = async function () {
    // Custom query to populate 'espacio'
    var espacio = await Espacio.findOne({
        elementos: { $all: this.elementos }
    });
    this.espacio =  espacio.name;
};

// Ensure virtual fields are serialized
ReservaSchema.set('toJSON', {
    virtuals: true,
});

export default mongoose.model('Reserva', ReservaSchema);