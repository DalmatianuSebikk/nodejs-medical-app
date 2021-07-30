const express = require('express');
const router = express.Router();
const path = require('path');
const url = require('url');
const fs = require('fs');
const { Client } = require('pg'); // pentru postgres
const { check, validationResult, matchedData } = require('express-validator');
const { match } = require('assert');
const flash = require('express-flash');
const csrf = require('csurf');
const rateLimit = require('express-rate-limit');
const nodemailer = require('nodemailer');
require('dotenv').config();
const {google} = require('googleapis');
const OAuth2 = google.auth.OAuth2; // for google oauth


const createTransporter = async () => {
    const oauth2Client = new OAuth2(
        process.env.CLIENT_OAUTH_ID,
        process.env.CLIENT_OAUTH_SECRET,
        "https://developers.google.com/oauthplayground"
    );

    oauth2Client.setCredentials({
        refresh_token: process.env.REFRESH_TOKEN
    });

    const accessToken = await new Promise((resolve, reject) => {
        oauth2Client.getAccessToken((err, token) => {
          if (err) {
            reject(err);
          }
          resolve(token);
        });
      });
    
    let transporter = nodemailer.createTransport({
        service: process.env.EMAIL_SERVICE,
        auth: {
            type: "OAuth2",
            user: process.env.EMAIL_SENDER,
            accessToken,
            clientId: process.env.CLIENT_OAUTH_ID,
            clientSecret: process.env.CLIENT_OAUTH_SECRET,
            refreshToken: process.env.REFRESH_TOKEN
        },
        tls: {
            rejectUnauthorized: false
        }
    });

    return transporter;
}



const postLimit = rateLimit({
    windowMs: 30 * 60 * 1000,
    statusCode: 429,
    max: 3,
    handler: (req, res) => {
        stringStatus = 'Prea multe request-uri. Incercati peste 30 minute din nou.';
        res.render('pagini/programare.ejs', {
            arr: req.session.cart, 
            lungime:req.session.cart.length, 
            x: 0, 
            index: 0,
            data: req.body,
            errors: {},
            eroareLimiter: stringStatus,
            csrfToken: req.csrfToken()
        });
    },
    onLimitReached: (req, res) => {
        res.redirect('/');
    }
});


const client = new Client({
    host:process.env.DB_HOST,
    user:process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT
});
client.connect();

const csrfProtection = csrf({ cookie: true });

router.get(['/', '/index'], async (req, res) => {
    // console.log(req.session.cart);
    console.log('Request pentru pagina principala.');
    // res.render('pagini/index.ejs');
    // IAU PRIMELE 3 ELEMENTE DIN TABELA DE ANALIZE
    var stringQuery1 = 'SELECT * FROM analize LIMIT 4';
    var stringQuery2 = 'SELECT * FROM consultatii ORDER BY nume LIMIT 4';
    var stringQuery3 = 'SELECT * FROM ecografii LIMIT 4';
    const rezultat = await client.query(stringQuery1, function(err, rez){
        // console.log(err, rez);
        client.query(stringQuery2, function(err, rez2){
            // console.log(err, rez2);
            client.query(stringQuery3, function(err, rez3){
                res.render('pagini/index.ejs', {
                    analize: rez.rows, 
                    consultatii:rez2.rows, 
                    ecografii:rez3.rows, 
                    lungime:req.session.cart.length
                });
            })
        })
    });
});

router.get('/programare-online', csrfProtection, (req, res) => {
    res.render('pagini/programare.ejs', {
        arr: req.session.cart, 
        lungime:req.session.cart.length, 
        x: 0, 
        index: 0,
        data: {},
        errors: {},
        eroareLimiter: '',
        succes: '',
        csrfToken: req.csrfToken()
    });
});

router.post('/programare-online', csrfProtection, [
    check('nume')
    .isLength({min: 2, max:50})
    .withMessage('Numele este prea scurt sau prea lung.')
    .isAlpha()
    .withMessage('Numele nu este corect.'),

    check('prenume')
    .isLength({min: 2, max:50})
    .withMessage('Prenumele este prea scurt.')
    .isAlpha()
    .withMessage('Prenumele nu este corect.'),

    check('numarDeTelefon')
    .isLength({min:10, max:12})
    .withMessage('Numarul de telefon nu este valid.')
    .isMobilePhone(['ro-RO'])
    .withMessage('Numarul de telefon trebuie sa fie de Romania.'),

    check('dataProgramare')
    .isDate()
    .withMessage('Data nu este valida.'),

    check('email')
    .isEmail()
    .bail()
    .trim()
    .normalizeEmail()
    .withMessage('E-mailul nu este valid.')
    .optional({nullable: true, checkFalsy: true}),

    check('_csrf'),

    check('locatie')

    ], postLimit, (req, res) => {
    console.log(res);
    const errors = validationResult(req);
    var stringStatus = '';
        if(!errors.isEmpty()){
            console.log("Nu e ok")
            res.render('pagini/programare.ejs', {
                arr: req.session.cart, 
                lungime:req.session.cart.length, 
                x: 0, 
                index: 0,
                data: req.body,
                errors: errors.mapped(),
                eroareLimiter: stringStatus,
                csrfToken: req.csrfToken()
            })
        }
        else{
            console.log('Ok. Verific cosul');
            // console.log(req);
            const data = matchedData(req);
            // data.push(req.session.cart);
            console.log('Date:', data);
            
            // TRANSMITEREA MAILULUI:
            var stringMail = 'Buna ziua, ma numesc ' + data.nume + ' ' + data.prenume + ' si doresc o programare pe data de ' + data.dataProgramare + ' la urmatoarele: ';
            for(var i = 0; i < req.session.cart.length; i++){
                stringMail += req.session.cart[i].nume;
                stringMail += ' ';
            }
            stringMail += 'la centrul medical din ' + data.locatie + '. Numarul meu de telefon este: ' + data.numarDeTelefon + '. ';
            if(data['email'] != undefined){
                stringMail += 'Mail-ul meu este: ' + data.email;
            }
            const sendEmail = async (mailOptions) =>{
                let emailTransporter = await createTransporter();
                emailTransporter.sendMail(mailOptions, (err, data) => {
                    if(err) {
                        console.log(err);
                    }
                    else{
                        console.log('Ok, trimis');
                        // res.flash('success', 'Programarea a fost facuta cu succes. Veti primi confirmarea prin apel telefonic sau prin e-mail.');
                        res.render('pagini/programare.ejs', {
                            arr: req.session.cart, 
                            lungime:req.session.cart.length, 
                            x: 0, 
                            index: 0,
                            data: {},
                            errors: {},
                            eroareLimiter: '',
                            succes:'Mesajul a fost trimis cu succes. Mesajul dumneavoastra este: ' + stringMail,
                            csrfToken: req.csrfToken()
                        });
                    }
                })
            }
            sendEmail(
                {
                    from: process.env.EMAIL_SENDER,
                    to: (data.locatie==='Dorohoi') ? process.env.EMAIL_DOROHOI : process.env.EMAIL_BOTOSANI,
                    subject: 'Programare investigatii',
                    text: stringMail
                }
            );
            // req.flash('success', 'Programarea a fost facuta cu succes. Veti primi confirmarea prin apel telefonic sau prin e-mail.');
        }
});

router.get('/search', async (req, res) => {
    console.log(req.query.key)
    let stringSearch = req.query.key;
    // stringSearch.toLowerCase();
    if(!req.query.key){
        let stringSearchQuery1 = "SELECT * FROM analize";
        let stringSearchQuery2 = "SELECT * FROM consultatii";
        let stringSearchQuery3 = "SELECT * FROM ecografii";
        const rezultat = await client.query(stringSearchQuery1, function(errAnalize, rezAnalize){
            if(errAnalize){
                console.log(errAnalize);
            }
            client.query(stringSearchQuery2, function(errConsultatii, rezConsultatii){
                if(errConsultatii){
                    console.log(errConsultatii);
                }
                client.query(stringSearchQuery3, function(errEcografii, rezEcografii){
                    if(errEcografii){
                        console.log(errEcografii);
                    }
                    res.render('pagini/search.ejs',{
                        cautare:req.query.key,
                        lungime:req.session.cart.length, 
                        analize: rezAnalize.rows,
                        consultatii: rezConsultatii.rows,
                        ecografii: rezEcografii.rows
                    });
                });
            })
        })
    }
    else{
        let stringSearchQuery1 = "SELECT * FROM analize WHERE LOWER(nume) LIKE '%" + stringSearch.toLowerCase() + "%'";
        let stringSearchQuery2 = "SELECT * FROM consultatii WHERE LOWER(nume) LIKE '%" + stringSearch.toLowerCase() + "%'";
        let stringSearchQuery3 = "SELECT * FROM ecografii WHERE LOWER(nume) LIKE '%" + stringSearch.toLowerCase() + "%'";
        const rezultat = await client.query(stringSearchQuery1, function(errAnalize, rezAnalize){
            if(errAnalize){
                console.log(errAnalize);
            }
            client.query(stringSearchQuery2, function(errConsultatii, rezConsultatii){
                if(errConsultatii){
                    console.log(errConsultatii);
                }
                client.query(stringSearchQuery3, function(errEcografii, rezEcografii){
                    if(errEcografii){
                        console.log(errEcografii);
                    }
                    res.render('pagini/search.ejs',{
                        cautare:req.query.key,
                        lungime:req.session.cart.length, 
                        analize: rezAnalize.rows,
                        consultatii: rezConsultatii.rows,
                        ecografii: rezEcografii.rows
                    });
                });
            })
        })
        
    }
})

router.get('/analize', async (req, res) => {
    
    if(!req.query.categorie){
        // DACA NU AM QUERY-URI, INSEAMNA CA E PRIMA DATA CAND ACCESEZ PAGINA RESPECTIVA
        console.log('Request pentru pagina de analize.');
        const rezultat = await client.query('SELECT * FROM analize', function(err, rez) {
            // console.log(err, rez);
            client.query('SELECT UNNEST(ENUM_RANGE( NULL::tipuri_analize)) AS categ', function(err, rezCateg){
                // console.log(err, rezCateg);
                res.render('pagini/analize.ejs', {
                    analize: rez.rows, 
                    categorii:rezCateg.rows, 
                    lungime:req.session.cart.length,
                    eroare: ''
                });
            });
        });
    }
    else{
        // ALTFEL, TRATAM NISTE EXCEPTII
        console.log('Request pentru pagina de analize DAR CU FILTRU');
        console.log(req.query.categorie, req.query.sortare);
        var stringQuery = "SELECT * FROM analize ";
        if(req.query.categorie != 'toate'){
            stringQuery += "WHERE tipanaliza='" + req.query.categorie + "'";
        }
        if(req.query.sortare){
            stringQuery += " ORDER BY nume";
        }
        const rezultat = await client.query(stringQuery, function(err, rez){
            console.log(stringQuery);
            if(err){
                console.log(err);
                const rezultat = client.query('SELECT * FROM analize', function(err, rez) {
                    // console.log(err, rez);
                    client.query('SELECT UNNEST(ENUM_RANGE( NULL::tipuri_analize)) AS categ', function(err, rezCateg){
                        // console.log(err, rezCateg);
                        res.render('pagini/analize.ejs', {
                            analize: rez.rows, 
                            categorii:rezCateg.rows, 
                            lungime:req.session.cart.length,
                            eroare: 'Categoria aleasa nu exista. Va rugam sa alegeti din nou.'
                        });
                    });
                });
            }
            else{
                client.query('SELECT UNNEST(ENUM_RANGE( NULL::tipuri_analize)) AS categ', function(err, rezCateg){
                    console.log(err, rezCateg);
                    res.render('pagini/analize.ejs', {
                        analize: rez.rows, 
                        categorii:rezCateg.rows, 
                        lungime:req.session.cart.length,
                        eroare: ''
                    });
                });
            }
           
        });
        
    }
    
});

router.get('/consultatii-ecografii', async(req, res) => {
    console.log('Request pentru pagina de consultatii si ecografii');
    var stringQuery = "Select * FROM consultatii ORDER BY nume";
    var stringQuery2 = "Select * FROM ecografii ORDER BY nume";
    const rezultat = client.query(stringQuery, function(err, rez) {
        console.log(err, rez);
        client.query(stringQuery2, function(err, rez2){
            res.render('pagini/consultatiiecografii.ejs', {
                consultatii: rez.rows, 
                ecografii: rez2.rows, 
                lungime:req.session.cart.length
            });
        })
    });
});

router.get('/cos', (req, res) => {
    res.render('pagini/cos.ejs', {
        arr: req.session.cart, 
        lungime:req.session.cart.length, 
        x: 0, 
        index: 0
    });
});

router.post('/analize/adauga/:id', async (req, res) => {
    var findById = 'SELECT * FROM analize WHERE id_analize=' + req.params.id;
    const rezultat = await client.query(findById, function(err, rez){

        console.log('--------------ADAUG IN CART PRODUSUL-----------');
        let found = req.session.cart.find(x => x.id_analize === rez.rows[0].id_analize); // verific daca nu e adaugat deja
        if(!found){
            req.session.cart.push(rez.rows[0]);
        }
        
        else{
            console.log('Nu-l mai adaug inca o data.');
        }
        console.log('---------------ACUM ARRAYUL DE PRODUSE ESTE: ' + JSON.stringify(req.session.cart) + '---------------------');
        res.redirect('/analize');
    });
});

router.post('/ecografii/adauga/:id', async (req, res) => {
    var findById = 'SELECT * FROM ecografii WHERE id_ecografie=' + req.params.id;
    const rezultat = await client.query(findById, function(err, rez){

        console.log('--------------ADAUG IN CART PRODUSUL-----------');
        let found = req.session.cart.find(x => x.id_ecografie === rez.rows[0].id_ecografie); // verific daca nu e adaugat deja
        if(!found){
            req.session.cart.push(rez.rows[0]);
        }
        
        else{
            console.log('Nu-l mai adaug inca o data.');
        }
        console.log('---------------ACUM ARRAYUL DE PRODUSE ESTE: ' + JSON.stringify(req.session.cart) + '---------------------');
        res.redirect('/consultatii-ecografii');
    });
})

router.post('/consultatii/adauga/:id', async (req, res) => {
    var findById = 'SELECT * FROM consultatii WHERE id_consultatie=' + req.params.id;
    const rezultat = await client.query(findById, function(err, rez){

        console.log('--------------ADAUG IN CART PRODUSUL-----------');
        let found = req.session.cart.find(x => x.id_consultatie === rez.rows[0].id_consultatie); // verific daca nu e adaugat deja
        if(!found){
            req.session.cart.push(rez.rows[0]);
        }
        
        else{
            console.log('Nu-l mai adaug inca o data.');
        }
        console.log('---------------ACUM ARRAYUL DE PRODUSE ESTE: ' + JSON.stringify(req.session.cart) + '---------------------');
        res.redirect('/consultatii-ecografii');
    });
})

router.post('/stergedincos/:index', async (req, res) => {
    // caut elementul in ambele baze de date
    req.session.cart.splice(req.params.index, 1);
    res.redirect('/cos');
});

module.exports = router;