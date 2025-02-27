import { Router } from 'express';
const router = Router();
import Alquiler from '../models/Alquiler.js';

router.post('/alquileres', async (req, res) => {
  try {
    const newAlquiler = new Alquiler(req.body);
    const savedAlquiler = await newAlquiler.save();
    res.status(201).json(savedAlquiler);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

router.get('/alquileres', async (req, res) => {
  try {
    const range = req.query.range ? JSON.parse(req.query.range) : [0, 9];
    const start = range[0];
    const end = range[1];

    const alquileres = await Alquiler.find()
      .populate('reservas')
      .populate('precios')
      .skip(start)
      .limit(end - start + 1);

    const total = await Alquiler.countDocuments();

    res.setHeader('Content-Range', `items ${start}-${end}/${total}`);
    res.json(alquileres);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

router.get('/alquileres/:id', async (req, res) => {
  try {
    const alquiler = await Alquiler.findById(req.params.id)
      .populate('reservas')
      .populate('precios');

    if (!alquiler) {
      return res.status(404).json({ message: 'Alquiler no encontrado' });
    }

    res.json(alquiler);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

router.put('/alquileres/:id', async (req, res) => {
  try {
    const alquilerId = req.params.id;
    const updatedData = req.body;

    const alquilerActualizado = await Alquiler.findByIdAndUpdate(
      alquilerId,
      {
        cantidad: updatedData.cantidad,
        reservas: updatedData.reservas,
        precios: updatedData.precios
      },
      { new: true, runValidators: true }
    )
    .populate('reservas')
    .populate('precios');

    if (!alquilerActualizado) {
      return res.status(404).json({ message: 'Alquiler no encontrado' });
    }

    res.json(alquilerActualizado);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

router.delete('/alquileres/:id', async (req, res) => {
  let delid = req.params['id'];
  try {
    await Alquiler.findOneAndDelete({ _id: delid });
    res.send("Deleted");
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

export default router;