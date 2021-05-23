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
        data:Buffer,
        contentType:String
    },
    startDate:{
        type:Date,
        default: Date.now
    },
    endDate:{
        type:Date,
        required:true
    },
    closed:{
        type:Boolean,
        default:false
    }
});


const EventForComputation = mongoose.model('EventForComputation',eventSchema);

module.exports = EventForComputation;