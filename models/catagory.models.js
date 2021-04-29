const mongoose = require('mongoose');
var catagorySchema = new mongoose.Schema({
    name:{
        type:String,
        required:true
    },
    photo:{
        data:String,
        contentType:String
    }
});
var Catagory = mongoose.model("Catagory",catagorySchema);

module.exports = Catagory;