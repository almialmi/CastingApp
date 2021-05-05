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
    approve:{
        type:String,
        default:"Pending",
        enum: ["Accept", "Reject","Pending"]
    },
    duration:{
        type:Number,
        required:true
    },
    dateForWork:{
        type:Date,
        required:true
    }
});

const Request = mongoose.model('Request',requestSchema);

module.exports = Request;
