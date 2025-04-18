import { Router } from 'express';
const router = Router()
import Reserva from '../models/Reserva.js';
import Espacio from '../models/Espacio.js';

router.post('/reservas', async (req, res) => {
    try {
        // TODO Validacion de superposicion de reservas, desconozco porque no me deja hacer reservas si lo descomento, suerte
        // const start = new Date(fechaInicio);
        // const end = new Date(fechaFin);

        // const existingReservas = await Reserva.find({
        //     elementos: { $in: elementos },
        //     $or: [
        // Caso 1: Nueva reserva se solapa por la izquierda
        //{ fechaInicio: { $lt: end }, fechaFin: { $gt: start } },
        // Caso 2: Nueva reserva se solapa por la derecha
        //{ fechaInicio: { $gte: start, $lte: end } },
        // Caso 3: Nueva reserva contiene completamente una existente
        //{ fechaFin: { $gte: start, $lte: end } }
        //]
        // });

        // if (existingReservas.length > 0) {
        //     return res.status(409).json({
        //         message: 'Conflicto de horario con reservas existentes',
        //         conflicts: existingReservas
        //     });
        // }

        const newReserva = new Reserva(req.body);
        const savedReserva = await newReserva.save();
        const populatedReserva = await Reserva.findById(savedReserva._id).populate('elementos').populate('clientes');

        await Espacio.findByIdAndUpdate(
            Espacio._id,
            { $push: { reservas: savedReserva._id } },
            { new: true }
        );

        res.status(200).json(populatedReserva);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

router.put('/reservas/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { elementos, cliente, ...reservaData } = req.body;

        const updatedReserva = await Reserva.findByIdAndUpdate(id,
            { ...reservaData, elementos, cliente },
            { new: true }
        ).populate('elementos').populate('clientes');

        if (!updatedReserva) {
            return res.status(404).json({ message: 'Reserva no encontrada' });
        }

        res.status(200).json(updatedReserva);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

router.delete('/reservas/:id', async (req, res) => {
    let delid = req.params['id'];
    try {
        await Reserva.findByIdAndDelete({ _id: delid });
        res.send("Deleted")
    } catch (error) {
        res.send(error)
    }
});


router.get('/reservas', async (req, res) => {
    const { fechaInicio, fechaFin, fechaSeleccionada, elementos } = req.query;
    if (fechaSeleccionada) {
        Reserva.find({ fecha: fechaSeleccionada }).populate('elementos').populate('clientes').exec((err, reservas) => {
            if (err) {
                res.status(500).json({ message: err.message });
            }
            res.status(200).json(reservas);
        });
    } else {


        if (!fechaInicio || !fechaFin) {
            return res.status(400).json({ message: 'fechaInicio and fechaFin are required' });
        }

        try {
            const filters = {
                fechaInicio: {
                    $gte: new Date(fechaInicio),
                    $lte: new Date(fechaFin)
                },
                fechaFin: {
                    $gte: new Date(fechaInicio),
                    $lte: new Date(fechaFin)
                }
            };

            if (elementos && elementos.length > 0) {
                filters.elementos = {
                    $in: elementos
                };
            }
            const reservas = await Reserva.find(filters).populate('elementos').populate('clientes');

            for (let reserva of reservas) {
                await reserva.populateEspacio();
            }

            res.status(200).json(reservas);
        } catch (error) {
            res.status(400).json({ message: error.message });
        }
    }
});

router.get('/reservas/check', async (req, res) => {
    const { elementoId, fechaInicio, fechaFin } = req.query;

    const reservas = await Reserva.find({
        elementos: elementoId,
        fechaInicio: {
            $gte: new Date(fechaInicio),
            $lte: new Date(fechaFin)
        },
        fechaFin: {
            $gte: new Date(fechaInicio),
            $lte: new Date(fechaFin)
        }
    });

    return res.json({ disponible: reservas.length === 0 });
});

router.get('/reservas/:id', async (req, res) => {

    try {
        const reserva = await Reserva.findById(req.params.id).populate('elementos').populate('clientes');
        if (!reserva) {
            return res.status(404).json({ message: 'Reserva no encontrado' });
        }

        res.status(200).json(reserva);
    } catch (error) {
        res.status(500).json({ message: 'Error al obtener la reserva', error });
    }
});

router.get('/reservas', async (req, res) => {
    try {
        const range = req.query.range ? JSON.parse(req.query.range) : [0, 9];
        const start = range[0];
        const end = range[1];

        const reservas = await Reserva.find()
            .skip(start)
            .limit(end - start + 1);

        const total = await Reserva.countDocuments();

        res.setHeader('Content-Range', `items ${start}-${end}/${total}`);

        res.status(200).json(reservas);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

export default router;