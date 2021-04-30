const mongoose = require('mongoose');

var eventSchema = new mongoose.Schema({
    name:{
        type:String,
        required:true
    },
    description:{
        type:String,
        required:true
    },
    category:{
        type:mongoose.Schema.Types.ObjectId,
        ref:"Catagory"
    },
    photo:{
        data:String,
        contentType:String
    },
    startDate:{
        type:Date,
        default: Date.now
    },
    endDate:{
        type:Date,
        required:true
    }
});


const EventForComputation = mongoose.model('EventForComputation',eventSchema);

module.exports = EventForComputation;