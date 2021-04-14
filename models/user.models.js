const mongoose = require('mongoose');
const uniqueValidator = require('mongoose-unique-validator');
const { use } = require('../routes/index.route');

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
        type:Number,
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
    photos:{
        data:Array,
        contentType:String
    },
    gender:{
        type:String,
        required:true
    },
    like:{
        type:Number,
        default:0
    },
    orderNumber:{
        type:Number,
        default:0
    }
});

userSchema.path('email').validate((val)=>{
    emailRegex =/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;
    return emailRegex.test(val);
},'Invalid e-mail');

userSchema.plugin(uniqueValidator);


const User = mongoose.model('User',userSchema);

module.exports = User;