const express = require('express');
const router = express.Router()
var espacios = require('../models/espacios');
module.exports = router;

router.post('/post', (req, res) => {
    res.send('Post API')
})

router.post('/espacio', async (req, res) => {
    espacios = new espacios({
        name: req.body.name,
        quantity: req.body.quantity,
        available: req.body.available,
    })

    try {
        const espaciosToSave = await espacios.save();
        res.status(200).json(espaciosToSave)
    }
    catch (error) {
        res.status(400).json({ message: error.message })
    }
})

router.put('/espacio/:id', async (req, res) => {

    let upid = req.params._id;
    let upname = req.body.name;
    let upquantity = req.body.quantity;
    let upavailable = req.body.available;
    try {
        await espacios.findOneAndUpdate({ id: upid }, { $set: { name: upname, quantity: upquantity, available: upavailable } }, { new: true })
        res.send("Updated")
    } catch (error) {
        res.send(error)
    }
})

router.delete('/espacio/:id', async (req, res) => {

    let delid = req.params._id;
    try {
        await espacios.findOneAndDelete({ id: delid })
        res.send("Deleted")
    } catch (error) {
        res.send(error)
    }
})