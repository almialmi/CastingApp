const mongoose = require('mongoose');

var requestSchema = new mongoose.Schema({
    description:{
        type:String,
        required:true
    },
    applyer:{
        type:mongoose.Schema.Types.ObjectId,
        ref:"Admin"
    },
    requestedUser:{
        type:mongoose.Schema.Types.ObjectId,
        ref:"User"
    },
    isApprove:{
        type:Boolean,
        default:false
    }
});

const Request = mongoose.model('Request',requestSchema);

module.exports = Request;
