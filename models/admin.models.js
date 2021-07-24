const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const uniqueValidator = require('mongoose-unique-validator');

// these values can be whatever you want - we're defaulting to a
// max of 5 attempts, resulting in a 2 hour lock
const MAX_LOGIN_ATTEMPTS = 5;
const LOCK_TIME = 2 * 60 * 60 * 1000;

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
    status: {
        type: String, 
        enum: ['Pending', 'Active'],
        default: 'Pending'
      },
    confirmationCode: { 
        type: Number, 
        unique: true 
    },
    password:{
        type:String,
        required:true,
        minlength:8
    },
    role:{
        type:String,
        default:'NormalUser',
        enum: ["NormalUser", "Admin"]
    },
    profilePic:{
        data:Buffer,
        contentType:String
    },
    loginAttempts:{
        type:Number,
        required:true,
        default:0

    },
    lockUntil:{
        type:Number
    },
    salSecrete: String
});

adminSchema.pre('save',function(next){
  if (this.isModified("password") || this.isNew) {
    bcrypt.genSalt(10,(err,salt)=>{
        bcrypt.hash(this.password,salt,(err,hash)=>{
            this.password = hash;
            this.salSecrete =salt;
            next();
        });
    });
  }
});

adminSchema.plugin(uniqueValidator);

adminSchema.virtual('isLocked').get(function() {
    // check for a future lockUntil timestamp
    return !!(this.lockUntil && this.lockUntil > Date.now());
})

adminSchema.methods.incrementLoginAttempts = function(callback) {
    // if we have a previous lock that has expired, restart at 1
    if (this.lockUntil && this.lockUntil < Date.now()) {
        return this.updateOne({
            $set: { loginAttempts: 1 },
            $unset: { lockUntil: 1 }
        }, callback);
    }
    // otherwise we're incrementing
    var updates = { $inc: { loginAttempts: 1 } };
    // lock the accout if we are reaching max attempts and its not locked already
    if (this.loginAttempts + 1 >= MAX_LOGIN_ATTEMPTS && !this.isLocked) 
    { 
        updates.$set = { lockUntil: Date.now() + LOCK_TIME }; 
    } 
    return this.updateOne(updates, callback); 
}

const Admin = mongoose.model('Admin',adminSchema);

module.exports = Admin;
