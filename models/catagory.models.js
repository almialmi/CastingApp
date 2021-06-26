const mongoose = require('mongoose');
const EventForComputation = require('../models/event.models');
const User = require('../models/user.models');

var catagorySchema = new mongoose.Schema({
    name:{
        type:String,
        required:true
    },
    photo:{
        data:Buffer,
        contentType:String
    }
});

catagorySchema.pre('remove', function(next) {
    EventForComputation.remove({category: this._id}).exec();
    User.remove({category: this._id}).exec();
    next();
});


var Catagory = mongoose.model("Catagory",catagorySchema);

module.exports = Catagory;