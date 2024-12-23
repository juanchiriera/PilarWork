import { Router } from 'express';
const router = Router()
import { Cliente } from '../models/Cliente.js'

router.post('/cliente', async (req, res) => {
    Cliente = new Cliente({
        name: req.body.name,
        surname: req.body.surname,
        mail: req.body.mail,
        phone: req.body.phone
    })

    try {
        const clientesToSave = await Cliente.save();
        res.status(200).json(clientesToSave)
    }
    catch (error) {
        res.send(error)
    }
})

router.put('/cliente/:id', async (req, res) => {

    let upid = req.params.ObjectId;
    let upname = req.body.name;
    let upsurname = req.body.surname;
    let upmail = req.body.mail;
    let phone = req.body.phone;
    try {
        await Cliente.findOneAndUpdate({ id: upid }, { $set: { name: upname, surname: upsurname, mail: upmail, phone: phone } }, { new: true })
        res.send("Updated")
    } catch (error) {
        res.send(error)
    }
})

router.delete('/cliente/:id', async (req, res) => {

    let delid = req.params.ObjectId;
    try {
        await Cliente.findOneAndDelete({ id: delid })
        res.send("Deleted")
    } catch (error) {
        res.send(error)
    }
})

export default router;