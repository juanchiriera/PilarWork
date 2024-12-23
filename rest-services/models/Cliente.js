import { mongoose } from 'mongoose';

const Cliente = new mongoose.Schema({
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

export default mongoose.model('clientes', Cliente)

export { Cliente as Cliente }