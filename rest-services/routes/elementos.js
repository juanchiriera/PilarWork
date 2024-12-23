import { Router } from 'express';
const router = Router()
import Elemento from '../models/Elemento.js'

router.post('/elemento', async (req, res) => {
    Elemento = new Elemento({
        name: req.body.name,
        quantity: req.body.quantity,
        available: req.body.available,
    })

    try {
        const elementosToSave = await Elemento.save();
        res.status(200).json(elementosToSave)
    }
    catch (error) {
        res.status(400).json({ message: error.message })
    }
})

router.put('/elemento/:id', async (req, res) => {

    let upid = req.params.ObjectId;
    let upname = req.body.name;
    let upquantity = req.body.quantity;
    let upavailable = req.body.available;
    try {
        await Elemento.findOneAndUpdate({ id: upid }, { $set: { name: upname, quantity: upquantity, available: upavailable } }, { new: true })
        res.send("Updated")
    } catch (error) {
        res.send(error)
    }
})

router.delete('/elemento/:id', async (req, res) => {

    let delid = req.params.ObjectId;
    try {
        await Elemento.findOneAndDelete({ id: delid })
        res.send("Deleted")
    } catch (error) {
        res.send(error)
    }
})

export default router;