import { Router } from 'express';
const router = Router()
import Espacio from '../models/Espacio.js';
import { Types } from 'mongoose';

router.post('/espacio', async (req, res) => {
    const espacio = new Espacio({
        name: req.body.name,
        quantity: req.body.quantity,
        available: req.body.available,
    })

    try {
        const savedEspacio = await espacio.save();
        res.status(200).json(savedEspacio)
    }
    catch (error) {
        res.status(400).json({ message: error.message })
    }
})

router.put('/espacio/:id', async (req, res) => {

    let upid = req.params['id'];
    let name = req.body.name;
    let quantity = req.body.quantity;
    let available = req.body.available;
    try {
        await Espacio.findOneAndUpdate(
            { id: upid },
            { $set: 
                { 
                    name: name,
                    quantity: quantity,
                    available: available
                } 
            }, { new: true })
        res.send("Updated")
    } catch (error) {
        res.send(error)
    }
})

router.delete('/espacio/:id', async (req, res) => {

    let delid = req.params['id'];
    try {
        await Espacio.findOneAndDelete({ id: delid })
        res.send("Deleted")
    } catch (error) {
        res.send(error)
    }
})

router.get('/espacio/:id', async (req, res) => {
    let id = req.params['id'];
    try{
        const ObjectId = Types.ObjectId
        let response = await Espacio.findById(new ObjectId(id))
        res.send(response)
    } catch (error) {
        res.send(error)
    }
})

export default router;