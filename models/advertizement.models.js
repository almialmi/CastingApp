const mongoose = require('mongoose');


var advertSchema = new mongoose.Schema({
    topic:{
        type:String,
        required:true
    },
    description:{
        type:String,
        required:true
    },
    status:{
        type:String,
        default:"Active",
        enum: ["Active", "Closed"]
    }
});



const Advertizement = mongoose.model('Advertizement',advertSchema);

module.exports = Advertizement;