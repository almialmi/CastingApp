const mongoose = require('mongoose');

var computationsSchema = new mongoose.Schema({
    user:{
        type:mongoose.Schema.Types.ObjectId,
        ref:"User"
    },
    eventForComputation:{
        type:mongoose.Schema.Types.ObjectId,
        ref:"EventForComputation"
    },
    video:{
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
    }],
    jugePoints:{
        type:Number,
        default:0
    }
});


const Computations = mongoose.model('Computations',computationsSchema);

module.exports = Computations;