const express = require('express');
const router = express.Router()
var elementos = require('../models/elementos');
module.exports = router;

router.post('/elemento', async (req, res) => {
    elementos = new elementos({
        name: req.body.name,
        quantity: req.body.quantity,
        available: req.body.available,
    })

    try {
        const elementosToSave = await elementos.save();
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
        await elementos.findOneAndUpdate({ id: upid }, { $set: { name: upname, quantity: upquantity, available: upavailable } }, { new: true })
        res.send("Updated")
    } catch (error) {
        res.send(error)
    }
})

router.delete('/elemento/:id', async (req, res) => {

    let delid = req.params.ObjectId;
    try {
        await elementos.findOneAndDelete({ id: delid })
        res.send("Deleted")
    } catch (error) {
        res.send(error)
    }
})