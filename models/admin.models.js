const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const uniqueValidator = require('mongoose-unique-validator');

var adminSchema = new mongoose.Schema({
    userName:{
        type:String,
        required:true
    },
    email:{
        type:String,
        required:true,
        unique: true
    },
    password:{
        type:String,
        required:true
    },
    role:{
        type:String,
        default:'NormalUser',
        enum: ["NormalUser", "Admin"]

    },
    salSecrete: String
});


adminSchema.path('email').validate((val)=>{
    emailRegex =/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;
    return emailRegex.test(val);
},'Invalid e-mail');

adminSchema.pre('save',function(next){
    bcrypt.genSalt(10,(err,salt)=>{
        bcrypt.hash(this.password,salt,(err,hash)=>{
            this.password = hash;
           this.salSecrete =salt;
            next();
        });
    });
});

adminSchema.plugin(uniqueValidator);


const Admin = mongoose.model('Admin',adminSchema);

module.exports = Admin;