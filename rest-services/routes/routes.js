const express = require('express');
const router = express.Router()
var espacios = require('../models/espacios');
module.exports = router;



router.post('/post', (req, res) => {
    res.send('Post API')
})

router.post('/postespacio', async (req, res) => {

    espacios = new espacios({
        name: req.body.name,
        quantity: req.body.quantity,
        available: req.body.available
    })

    try {
        const espaciosToSave = await espacios.save();
        res.status(200).json(espaciosToSave)
    }
    catch (error) {
        res.status(400).json({message: error.message})
    }
})
