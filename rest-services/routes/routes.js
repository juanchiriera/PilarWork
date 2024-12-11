const express = require('express');
const espacios = require('../models/espacios');

const router = express.Router()

module.exports = router;



router.post('/post', (req, res) => {
    res.send('Post API')
})

router.post('/postespacio', (req, res) => {
    const espacios = new espacios({
        name: req.body.name,
        quantity: req.body.quantity,
        available: req.body.available
    })

    try {
        const espaciosToSave = espacios.save();
        res.status(200).json(espaciosToSave)
    }
    catch (error) {
        res.status(400).json({message: error.message})
    }
})
