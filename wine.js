const express = require('express');
const app = express();
const bodyParser= require('body-parser');
const mongoose = require('mongoose');
var jwt = require('jsonwebtoken');
const { Schema } = mongoose;


const User = mongoose.model('myCollection3211', new Schema( { ident: String, passwd: String, admin: Boolean} ));
User.collection.drop();
const Vin = mongoose.model('myCollection3212', new Schema({ nom: String, domaine: String, annee: String, commentaires: [{nom: String, commentaire: String, note: Number}]}));
Vin.collection.drop();

const mongoAccess = 'mongodb://127.0.0.1:27017/db';

var KEY = "ça c'est un gros gros SECRET Eh_ouais";

mongoose.connect(mongoAccess, {useNewUrlParser: true, useUnifiedTopology: true});

const cors = require('cors');
app.use(cors());

const wiak = new User({ident: 'wiak', passwd: 'def3265f1ee9dd63fa71eff906a4014804569589a799224ee8915e929c0fbff0', admin: true});
const vinRandom = new Vin({nom: 'WineName', domaine : 'WineDomain', annee: 'xxxx'});
const vinRandom2 = new Vin({nom: 'WiddneName', domaine : 'WinessDomain', annee: 'xxsxx'});

vinRandom.commentaires.push({ident:'wiak', commentaire: 'ceci est une comm!', note: 9});
vinRandom.commentaires.push({ident:'wiffak', commentaire: 'ceci estddddd une comm!', note: '5'});
wiak.save().then(() => console.log("ajout de l'user"));
vinRandom2.save();
vinRandom.save().then(() => console.log("ajout du vin"));



app.listen(3211, function() {
	console.log('Listening on port 3211');
});

app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json({limit: '10mb'}));

app.post('/api/getwine', async function (request, response) {
	let nameWines = await Vin.find().select('nom');
	let scan = request.body.scan;
	console.log(nameWines);
	let idWine;
	for (let index = 0; index < nameWines.length; index++) {
		const element = nameWines[index]["nom"];
		if (scan.includes(element)) idWine = nameWines[index]["_id"];
	}
	if(idWine !=null) {
		let wine = await Vin.findOne({_id: idWine});
		response.status(200).send(wine);
	}
	else response.status(401).send("Nous n'avons pas trouvé de vin correspondant à la bouteille que vous avez pris en photo.")
});

app.post('/login', async function (request, response) {
	console.log("requete reçu");
	let ident = request.body.ident;
	let passwd = request.body.passwd;
	let user = await User.findOne( {ident: ident} );
	if (user) {
		if (user.passwd == passwd) {
			var payload = {
				ident : user["ident"],
				admin : user["admin"],
			}
			var token = jwt.sign(payload, KEY, {algorithm: "HS256", expiresIn: "15d"});
			response.status(200).send(token);
		}
		else {
			response.status(401).send("Mauvais mot de passe");
		}
	}
	else {
		response.status(401).send("Utilisateur n'existe pas");
	}
});

app.post('/signup', async function (request, response) {
	let ident = request.body.ident;
	let passwd = request.body.passwd;
	let admin = request.body.admin;
	let user = await User.findOne( {ident: ident} );
	if (user) {
		response.status(200).send("Utilisateur existe déjà");
	}
	else {
		await User.create( {ident: ident, passwd: passwd, admin: admin} );
		response.status(200).send("Utilisateur crée");
	}
});
