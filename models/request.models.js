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
        enum: ["Accepted", "Rejected","Pending"]
    },
    duration:{
        type:String,
        required:true
    },
    dateForWork:{
        type:Date,
        required:true
    }
});

const Request = mongoose.model('Request',requestSchema);

module.exports = Request;
