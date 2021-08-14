const mongoose = require('mongoose');
const ComputationPost = require('../models/computationPost.models');

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
       type:String,
       required:true
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

eventSchema.pre('remove', function(next) {
    ComputationPost.remove({eventForComputation: this._id}).exec();
    next();
});


const EventForComputation = mongoose.model('EventForComputation',eventSchema);

module.exports = EventForComputation;