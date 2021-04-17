require('./config/config');
require('./models/db');
const express = require('express');
const passport = require('passport');
const cors = require('cors');
const rstIndex = require('./routes/index.route');
const app = express();

app.use(express.json());
app.use(express.urlencoded({extended:true}));
app.use(cors());
require('./config/passportConfig')(passport);
app.use('/api',rstIndex);




app.listen(process.env.PORT,() => console.log('Server started at port:' + process.env.PORT));



