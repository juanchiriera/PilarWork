const express = require('express');
const router = express.Router()
var clientes = require('../models/clientes');
module.exports = router;

router.post('/post', (req, res) => {
    res.send('Post API')
})

router.post('/cliente', async (req, res) => {
    clientes = new clientes({
        name: req.body.name,
        apellido: req.body.apellido,
        mail: req.body.mail,
        telefono: req.body.telefono
    })

    try {
        const clientesToSave = await clientes.save();
        res.status(200).json(clientesToSave)
    }
    catch (error) {
        res.status(400).json({ message: error.message })
    }
})

router.put('/cliente/:id', async (req, res) => {

    let upid = req.params._id;
    let upname = req.body.name;
    let upapellido = req.body.apellido;
    let upmail = req.body.mail;
    let uptelefono = req.body.telefono;
    try {
        await clientes.findOneAndUpdate({ id: upid }, { $set: { name: upname, apellido: upapellido, mail: upmail, telefono: uptelefono } }, { new: true })
        res.send("Updated")
    } catch (error) {
        res.send(error)
    }
})

router.delete('/cliente/:id', async (req, res) => {

    let delid = req.params._id;
    try {
        await clientes.findOneAndDelete({ id: delid })
        res.send("Deleted")
    } catch (error) {
        res.send(error)
    }
})
