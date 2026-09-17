/**
 * =========================================================
 *  DAKAR PHARMA API - VERSION PEDAGOGIQUE COMPLETE
 * =========================================================
 *
 * OBJECTIF :
 * ---------
 * Comprendre :
 * 1. Différence entre route publique et route protégée
 * 2. Fonctionnement du JWT
 * 3. Rôle des middlewares
 * 4. Sécurité dans une API REST
 *
 * IMPORTANT :
 * ----------
 * Dans une API professionnelle :
 * - Les routes GET sont souvent publiques
 * - Les routes POST / PUT / DELETE sont protégées
 */

const express = require('express');
const jwt = require('jsonwebtoken');

const app = express();
const PORT = 4000;

/**
 * Middleware global
 * Permet à Express de comprendre les données JSON
 */
app.use(express.json());

/**
 * Clé secrète utilisée pour signer les tokens JWT.
 * ⚠️ En production : utiliser process.env.SECRET_KEY
 */
const SECRET_KEY = "DAKAR_221_PROLE_KEY";


// =========================================================
// 1️⃣ BASE DE DONNÉES SIMULÉE
// =========================================================

/**
 * ⚠️ Ceci est une base temporaire en mémoire.
 * Les données disparaissent au redémarrage.
 */

let pharmacies = [
    { id: 1, nom: "Pharmacie Nation", ville: "Dakar", quartier: "Plateau", garde: true, stock: 100 },
    { id: 2, nom: "Pharmacie Touba", ville: "Touba", quartier: "Darou", garde: false, stock: 50 }
];


// =========================================================
// 2️⃣ AUTHENTIFICATION
// =========================================================

/**
 * ROUTE LOGIN
 *
 * Simulation d’un pharmacien.
 * En réalité :
 * - On vérifierait email + mot de passe
 * - On comparerait le mot de passe hashé
 */

app.post('/login', (req, res) => {

    const user = {
        id: 1,
        username: "pharmacien_dakar",
        role: "PHARMACIEN"
    };

    /**
     * jwt.sign()
     * 1. Données à encoder
     * 2. Clé secrète
     * 3. Durée de validité
     */
    jwt.sign({ user }, SECRET_KEY, { expiresIn: '1h' }, (err, token) => {

        if (err) {
            return res.status(500).json({ message: "Erreur génération token" });
        }

        res.json({
            message: "Connexion réussie",
            token: token
        });
    });
});


// =========================================================
// 3️⃣ MIDDLEWARE DE SECURITE
// =========================================================

/**
 * verifierToken
 *
 * Cette fonction agit comme un garde de sécurité.
 *
 * Étapes :
 * 1. Vérifie présence du header Authorization
 * 2. Récupère le token
 * 3. Vérifie sa validité
 * 4. Autorise ou bloque
 */

const verifierToken = (req, res, next) => {

    const header = req.headers['authorization'];

    // 1️⃣ Vérifier si le token est présent
    if (!header) {
        return res.status(401).json({
            message: "Accès refusé : aucun token fourni"
        });
    }

    // 2️⃣ Extraire le token (format : Bearer TOKEN)
    const token = header.split(' ')[1];

    // 3️⃣ Vérifier validité
    jwt.verify(token, SECRET_KEY, (err, decoded) => {

        if (err) {
            return res.status(403).json({
                message: "Token invalide ou expiré"
            });
        }

        // 4️⃣ Ajouter les infos utilisateur dans la requête
        req.user = decoded.user;

        // 5️⃣ Autoriser accès
        next();
    });
};


// =========================================================
// 4️⃣ ROUTES CRUD
// =========================================================


/**
 * =====================================================
 * 4.1 GET - ROUTE PUBLIQUE
 * =====================================================
 *
 * Pourquoi publique ?
 * Parce que lire la liste des pharmacies
 * ne modifie pas les données.
 */

app.get('/pharmacies', (req, res) => {

    res.status(200).json(pharmacies);
});


/**
 * =====================================================
 * 4.2 POST - ROUTE SECURISEE
 * =====================================================
 *
 * Création = modification du système
 * Donc nécessite authentification
 */

app.post('/pharmacies', verifierToken, (req, res) => {

    const { nom, ville, quartier, garde, stock } = req.body;

    if (!nom || !ville) {
        return res.status(400).json({
            message: "Nom et ville obligatoires"
        });
    }

    const nouvelle = {
        id: pharmacies.length + 1,
        nom,
        ville,
        quartier,
        garde: garde || false,
        stock: stock || 0
    };

    pharmacies.push(nouvelle);

    res.status(201).json({
        message: "Pharmacie ajoutée par " + req.user.username,
        data: nouvelle
    });
});


/**
 * =====================================================
 * 4.3 PUT - ROUTE SECURISEE
 * =====================================================
 */

app.put('/pharmacies/:id', verifierToken, (req, res) => {

    const id = parseInt(req.params.id);
    const pharma = pharmacies.find(p => p.id === id);

    if (!pharma) {
        return res.status(404).json({
            message: "Pharmacie introuvable"
        });
    }

    Object.assign(pharma, req.body);

    res.json({
        message: "Modification effectuée par " + req.user.username,
        data: pharma
    });
});


/**
 * =====================================================
 * 4.4 DELETE - ROUTE SECURISEE
 * =====================================================
 */

app.delete('/pharmacies/:id', verifierToken, (req, res) => {

    const id = parseInt(req.params.id);
    const existe = pharmacies.some(p => p.id === id);

    if (!existe) {
        return res.status(404).json({
            message: "Pharmacie introuvable"
        });
    }

    pharmacies = pharmacies.filter(p => p.id !== id);

    res.json({
        message: "Suppression effectuée par " + req.user.username
    });
});


/**
 * =====================================================
 * 4.5 STOCK - ROUTE SECURISEE
 * =====================================================
 *
 * Pourquoi particulièrement sécurisée ?
 * Parce que le stock impacte :
 * - Les ventes
 * - La comptabilité
 * - Les revenus
 */

app.put('/pharmacies/:id/stock', verifierToken, (req, res) => {

    const id = parseInt(req.params.id);
    const pharma = pharmacies.find(p => p.id === id);

    if (!pharma) {
        return res.status(404).json({
            message: "Pharmacie introuvable"
        });
    }

    pharma.stock = req.body.stock ?? pharma.stock;

    res.json({
        message: "Stock mis à jour par " + req.user.username,
        data: pharma
    });
});


// =========================================================
// 5️⃣ LANCEMENT SERVEUR
// =========================================================

app.listen(PORT, () => {
    console.log("Serveur lancé sur http://localhost:" + PORT);
});