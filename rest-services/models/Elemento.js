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

// Add a virtual field 'id' that gets the value from '_id'
ElementoSchema.virtual('id').get(function () {
    return this._id.toHexString();
});

// Ensure virtual fields are serialized
ElementoSchema.set('toJSON', {
    virtuals: true,
});

export default mongoose.model('Elemento', ElementoSchema);