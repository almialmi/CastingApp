require('./config/config');
require('./models/db');
const rateLimit = require("express-rate-limit");
const express = require('express');
const passport = require('passport');
const cors = require('cors');
const cookieParser = require('cookie-parser');
const mongoSanitize = require('express-mongo-sanitize');
const helmet = require("helmet");
const rstIndex = require('./routes/index.route');
const app = express();

const limiter = rateLimit({
    max: 100,
    windowMs: 60 * 60 * 1000,
    message: "Too many request"
});

app.use(express.json({limit: '50mb'}));
app.use(express.urlencoded({limit: '50mb',extended:true}));
app.use(cors({
    origin: [
      'http://localhost:3000',
      'http://127.0.0.1:3000',
    ],
    credentials: true
  }));
app.use('/api/adminProfilePicStorage',express.static('adminProfilePicStorage'))
app.use('/api/categoryPhotoStorage',express.static('categoryPhotoStorage'))
app.use(cookieParser());
app.use(mongoSanitize()); 
app.use(helmet());
require('./config/passportConfig')(passport);
app.use('/api',rstIndex);
app.use(limiter);


app.listen(process.env.PORT,() => console.log('Server started at port:' + process.env.PORT));



