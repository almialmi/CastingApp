require('./config/config');
require('./models/db');
const rateLimit = require("express-rate-limit");
const express = require('express');
const passport = require('passport');
const cors = require('cors');
const rstIndex = require('./routes/index.route');
const app = express();

const limiter = rateLimit({
    max: 100,
    windowMs: 60 * 60 * 1000,
    message: "Too many request"
});

app.use(express.json());
app.use(express.urlencoded({extended:true}));
app.use(cors());
require('./config/passportConfig')(passport);
app.use('/api',rstIndex);
app.use(limiter);


app.listen(process.env.PORT,() => console.log('Server started at port:' + process.env.PORT));



