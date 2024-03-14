const express = require('express');
const app = express();

const admin = require("firebase-admin");
const credentials = require("./key.json");

admin.initializeApp({
    credential: admin.credential.cert(credentials)
});

app.use(express.json());

app.use(express.urlencoded({extended: true}));

const db = admin.firestore();

const PORT = process.env.PORT || 8080;

app.post('/create', async (req, res) => {
    try{
        const id = req.body.name;
        const activityJson = {
            name: req.body.name,
            data: req.body.data
        };
        const response = db.collection("actividades").doc(id).set(activityJson);
        res.send(response);
    } catch (error) {
        res.send(error);
    }
});

app.get('/read/all', async (req, res) => {
    try {
        const activityRef = db.collection("actividades").limit(20);
        const response = await activityRef.get();
        let responseArr = [];
        response.forEach(doc => {
            responseArr.push(doc.data());
        });
        res.status(200).send(responseArr);
    } catch (error){
        res.send(error);
    }
});



//Obtener 1 documento
app.get('/read/:id', async (req, res) => {
    try {
        const activityRef = db.collection("actividades").doc(req.params.id);
        const response = await activityRef.get();
        res.send(response.data());
    } catch (error){
        res.send(error);
    }
});

/*app.post('/update', async(req, res) => {
    try {
        const id = req.body.id;
        const newData = "newDATA!"
        const activityRef = await db.collection("actividades").doc(id)
        .update({
            data: newData
        });
        res.send(response.data());
    }
    catch (error){
        res.send(error);
    }
});*/

/*app.delete('/delete/:id', async(req, res) => {
    try {
        const response = await db.collection("actividades").doc(req.params.id).delete();
        res.send(response.data());
    }
    catch (error){
        res.send(error);
    }
});*/

app.listen(PORT, () => {
    console.log(`Server is working on PORT ${PORT}`);
});