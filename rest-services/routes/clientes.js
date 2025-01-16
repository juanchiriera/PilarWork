import { Router } from 'express';
const router = Router()
import Cliente from '../models/Cliente.js'

router.post('/clientes', async (req, res) => {
    try {
        const cliente = new Cliente(req.body);
        const savedCliente = await cliente.save();
        res.status(201).json({
            data: {
                id: savedCliente._id,
                ...savedCliente.toObject(),
            },
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

router.put('/clientes/:id', async (req, res) => {
    try {
        const updatedData = req.body;

        const updatedCliente = await Cliente.findByIdAndUpdate(
            req.params.id,
            {
                name: updatedData.name,
                surname: updatedData.surname,
                mail: updatedData.mail,
                phone: updatedData.phone,
            },
            { new: true }
        ).lean();

        if (!updatedCliente) {
            return res.status(404).json({ message: "Cliente no encontrado" });
        }

        updatedCliente.id = updatedCliente._id;
        delete updatedCliente._id;

        res.status(200).json({ data: updatedCliente });
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

router.delete('/clientes/:id', async (req, res) => {
    try {
        const deletedCliente = await Cliente.findByIdAndDelete(req.params.id).lean();

        if (!deletedCliente) {
            return res.status(404).json({ message: "Cliente no encontrado" });
        }

        deletedCliente.id = deletedCliente._id;
        delete deletedCliente._id;

        res.status(200).json({ data: deletedCliente });
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

router.get('/clientes/:id', async (req, res) => {
    try {
        const cliente = await Cliente.findById(req.params.id);
        if (!cliente) {
            return res.status(404).json({ message: 'Cliente no encontrado' });
        }

        const formattedCliente = {
            id: cliente._id,
            ...cliente.toObject(),
        };

        delete formattedCliente._id;

        res.status(200).json({ data: formattedCliente });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

router.get('/clientes', async (req, res) => {
    try {
        const range = req.query.range ? JSON.parse(req.query.range) : [0, 9];
        const start = range[0];
        const end = range[1];

        const clientes = await Cliente.find()
            .skip(start)
            .limit(end - start + 1);

        const total = await Cliente.countDocuments();

        const formattedClientes = clientes.map(cliente => ({
            id: cliente._id,
            ...cliente.toObject(),
        }));

        res.setHeader('Content-Range', `clientes ${start}-${end}/${total}`);
        res.status(200).json(formattedClientes);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

export default router;