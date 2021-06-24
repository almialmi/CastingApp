const mongoose = require('mongoose');
const uniqueValidator = require('mongoose-unique-validator');
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
        required:true,
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
        data:Buffer,
        contentType:String
    },
    photo2:{
        data:Buffer,
        contentType:String
    },
    photo3:{
        data:Buffer,
        contentType:String
    },
    photo4:{
        data:Buffer,
        contentType:String
    },
    gender:{
        type:String,
        required:true
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

userSchema.path('email').validate((val)=>{
    emailRegex =/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;
    return emailRegex.test(val);
},'Invalid e-mail');

userSchema.plugin(uniqueValidator);


const User = mongoose.model('User',userSchema);

module.exports = User;