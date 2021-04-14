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
        data:String,
        contentType:String

    },
    like:{
        type:Number,
        default:0
    },
    jugePoints:{
        type:Number,
        default:0
    }
});


const Computations = mongoose.model('Computations',computationsSchema);

module.exports = Computations;