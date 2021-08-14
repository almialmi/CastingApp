const mongoose = require('mongoose');
const uniqueValidator = require('mongoose-unique-validator');
const ComputationPost = require('../models/computationPost.models');
const Request = require('../models/request.models');

var userSchema = new mongoose.Schema({
    firstName:{
        type:String,
        required:true
    },
    lastName:{
        type:String,
        required:true
    },
    email:{
        type:String,
        unique: true
    },
    mobile:{
        type:String,
        required:true
    },
    category:{
        type:mongoose.Schema.Types.ObjectId,
        ref:"Catagory"
    },
    video:{
        type:String,
        required:true

    },
    photo1:{
        type:String,
        required:true
    },
    photo2:{
        type:String,
        required:true
    },
    photo3:{
        type:String,
        required:true
    },
    gender:{
        type:String,
        default:'Female',
        enum: ["Female", "Male"]
    },
    like:[{
        type:mongoose.Schema.Types.ObjectId,
        ref:"Admin"
    }],
    disLike:[{
        type:mongoose.Schema.Types.ObjectId,
        ref:"Admin"
    }]
});

userSchema.plugin(uniqueValidator);

userSchema.pre('remove', function(next) {
    ComputationPost.remove({user: this._id}).exec();
    Request.remove({requestedUser: this._id}).exec();
    next();
});

const User = mongoose.model('User',userSchema);

module.exports = User;