import { Router } from 'express';
const router = Router()
import Espacio from '../models/Espacio.js';
import Elemento from '../models/Elemento.js';

router.post('/espacios', async (req, res) => {
    try {
        const newEspacio = new Espacio(req.body);

        if (req.body.elementos && req.body.elementos.length > 0) {
            newEspacio.elementos = [];

            for (const elementoData of req.body.elementos) {
                const newElemento = new Elemento({
                    name: elementoData.name,
                    quantity: elementoData.quantity,
                    available: elementoData.available,
                });

                const savedElemento = await newElemento.save();
                newEspacio.elementos.push(savedElemento._id);
            }
        }

        const savedEspacio = await newEspacio.save();

        const populatedEspacio = await Espacio.findById(savedEspacio._id).populate('elementos');

        res.status(200).json(populatedEspacio);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

router.put('/espacios/:id', async (req, res) => {
    try {
        const espacioId = req.params.id;
        const updatedData = req.body;

        const updatedEspacio = await Espacio.findByIdAndUpdate(
            espacioId, 
            {
                name: updatedData.name,
                quantity: updatedData.quantity,
                available: updatedData.available,
            }, 
            { new: true }
        );

        if (!updatedEspacio) {
            return res.status(404).json({ message: 'Espacio no encontrado' });
        }

        if (updatedData.elementos && updatedData.elementos.length > 0) {
            updatedEspacio.elementos = [];

            for (const elementoData of updatedData.elementos) {
                const newElemento = new Elemento({
                    name: elementoData.name,
                    quantity: elementoData.quantity,
                    available: elementoData.available,
                });

                const savedElemento = await newElemento.save();

                updatedEspacio.elementos.push(savedElemento._id);
            }
        }

        const savedUpdatedEspacio = await updatedEspacio.save();

        const populatedEspacio = await Espacio.findById(savedUpdatedEspacio._id).populate('elementos');

        res.status(200).json( populatedEspacio );
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

router.delete('/espacios/:id', async (req, res) => {

    let delid = req.params['id'];
    try {
        await Espacio.findOneAndDelete({ _id: delid })
        res.send("Deleted")
    } catch (error) {
        res.send(error)
    }
})

router.get('/espacios/:id', async (req, res) => {
    try {
        const espacio = await Espacio.findById(req.params.id).populate('elementos', 'name');
        if (!espacio) {
            return res.status(404).json({ message: 'Espacio no encontrado' });
        }
        
        res.status(200).json(espacio);
    } catch (error) {
        res.status(500).json({ message: 'Error al obtener el espacio', error });
    }
});

router.get('/espacios', async (req, res) => {
    try {
        const range = req.query.range ? JSON.parse(req.query.range) : [0, 9];
        const start = range[0];
        const end = range[1];

        const espacios = await Espacio.find()
            .skip(start)
            .limit(end - start + 1);

        const total = await Espacio.countDocuments();

        res.setHeader('Content-Range', `items ${start}-${end}/${total}`);

        res.status(200).json(espacios);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

export default router;