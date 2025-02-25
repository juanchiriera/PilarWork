import { Router } from 'express';
const router = Router()
import Precio from '../models/Precio.js';

router.post('/precios', async (req, res) => {
  try {
    const newPrecio = new Precio(req.body);

    const savedPrecio = await newPrecio.save();

    res.status(201).json(savedPrecio);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

router.get('/precios', async (req, res) => {
  try {
    const range = req.query.range ? JSON.parse(req.query.range) : [0, 9];
    const start = range[0];
    const end = range[1];

    const precios = await Precio.find().populate('espacios', 'nombre')
      .skip(start)
      .limit(end - start + 1);

    const total = await Precio.countDocuments();

    res.setHeader('Content-Range', `items ${start}-${end}/${total}`);
    res.json(precios);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

router.get('/precios/:id', async (req, res) => {
  try {
    const precio = await Precio.findById(req.params.id).populate('espacios');

    if (!precio) {
      return res.status(404).json({ message: 'Precio no encontrado' });
    }

    res.json(precio);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

router.put('/precios/:id', async (req, res) => {
  try {
    const precioId = req.params.id;
    const updatedData = req.body;

    const precioActualizado = await Precio.findByIdAndUpdate(
      precioId,
      {
        medida: updatedData.medida,
        valor: updatedData.valor,
        espacios: updatedData.espacios
      },
      { new: true, runValidators: true }
    ).populate('espacios');

    if (!precioActualizado) {
      return res.status(404).json({ message: 'Precio no encontrado' });
    }

    res.json(precioActualizado);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

router.delete('/precios/:id', async (req, res) => {
  let delid = req.params['id'];
  try {
    await Precio.findOneAndDelete({ _id: delid })
    res.send("Deleted")
  } catch (error) {
    res.send(error)
  }
});

export default router;
