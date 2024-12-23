import { Router } from 'express';
const router = Router()
import Espacio from '../models/Espacio.js';
import Elemento from '../models/Elemento.js';
import { Types } from 'mongoose';

router.post('/espacio', async (req, res) => {
    try {
        const elementosData = req.body.elementos; // Array de objetos para elementos
        const elementosIds = [];

        // Verificar que los elementos existan en el body
        if (elementosData && elementosData.length > 0) {
            for (const elemento of elementosData) {
                const newElemento = new Elemento({
                    name: elemento.name,
                    quantity: elemento.quantity,
                    available: elemento.available,
                });

                const savedElemento = await newElemento.save();
                elementosIds.push(savedElemento._id); // Guardar el ID del elemento
            }
        }

        const espacio = new Espacio({
            name: req.body.name,
            quantity: req.body.quantity,
            available: req.body.available,
            elementos: elementosIds,
        });

        const savedEspacio = await espacio.save();

        // Populate para incluir los datos completos de los elementos
        const populatedEspacio = await Espacio.findById(savedEspacio._id).populate('elementos');

        res.status(200).json(populatedEspacio);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

router.put('/espacio/:id', async (req, res) => {
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

        res.status(200).json(populatedEspacio);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

router.delete('/espacio/:id', async (req, res) => {

    let delid = req.params['id'];
    try {
        await Espacio.findOneAndDelete({ _id: delid })
        res.send("Deleted")
    } catch (error) {
        res.send(error)
    }
})

router.get('/espacio/:id', async (req, res) => {
    let id = req.params['id'];
    try{
        const ObjectId = Types.ObjectId
        let response = await Espacio.findById(new ObjectId(id)).populate('elementos');
        res.send(response)
    } catch (error) {
        res.send(error)
    }
})

export default router;