import mongoose, { Schema } from 'mongoose';

const ClienteSchema = new Schema({
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

export default mongoose.model('Cliente', ClienteSchema);