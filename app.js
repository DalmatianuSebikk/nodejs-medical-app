const express = require('express');
const fs = require('fs');
const path = require('path');
const routes = require('./routes');
var session = require('express-session');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const flash = require('express-flash');
var csrf = require('csurf');
const rateLimit = require("express-rate-limit");
require('dotenv').config();
// declarare app

const app = express();

// app.use(express.cookieParser());



app.set('views', path.join(__dirname, 'views')); // folosesc app.set pentru asta
app.use(express.static(path.join(__dirname, 'assets')));
// app.use(express.static(path.join(__dirname, "assets/galerie")));
app.use(express.static(path.join(__dirname, 'js')));
app.use(express.static(path.join(__dirname, "css")));
app.set(express.static(path.join(__dirname, 'node_modules')));


const middlewares = [
    session({
        secret:'scrt-key',
        resave: false,
        saveUninitialized: false
    }),
    express.urlencoded({ extended: true }),
    flash()
];

app.use(middlewares);
app.use(cookieParser());
// app.use(csrf({ cookie: true }));
app.use((req, res, next) => {
    if(!req.session.cart){
        req.session.cart = [];
        console.log('Creat session cart! :)');
    }
    
    next();
});

app.use('/', routes);

app.use('/*',function(req, res) {
    res.status(404);
    res.render('pagini/eroare', {lungime:req.session.cart.length});
});

// setez view-engine ul la ejs
app.set('view engine', 'ejs');
// app.engine('ejs', engine);

app.listen(process.env.PORT, () => {console.log("Serverul a pornit...")});