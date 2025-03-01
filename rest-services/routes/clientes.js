import { Router } from 'express';
const router = Router()
import Cliente from '../models/Cliente.js'

router.post('/clientes', async (req, res) => {
       const cliente = new Cliente({
            name: req.body.name,
            surname: req.body.surname,
            email: req.body.email,
            phone: req.body.phone,
        })

    try {
        const clienteToSave = await cliente.save();
        res.status(200).json(clienteToSave);
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
        )

        if (!updatedCliente) {
            return res.status(404).json({ message: "Cliente no encontrado" });
        }

        res.status(200).json(updatedCliente);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

router.delete('/clientes/:id', async (req, res) => {
    try {
        const deletedCliente = await Cliente.findByIdAndDelete(req.params.id);

        if (!deletedCliente) {
            return res.status(404).json({ message: "Cliente no encontrado" });
        }

        res.status(200).json(deletedCliente);
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

        res.status(200).json(cliente);
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

        res.setHeader('Content-Range', `clientes ${start}-${end}/${total}`);
        res.status(200).json(clientes);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

export default router;