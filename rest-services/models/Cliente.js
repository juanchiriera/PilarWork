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

// Add a virtual field 'id' that gets the value from '_id'
ClienteSchema.virtual('id').get(function () {
    return this._id.toHexString();
});

// Ensure virtual fields are serialized
ClienteSchema.set('toJSON', {
    virtuals: true,
});

export default mongoose.model('Cliente', ClienteSchema);