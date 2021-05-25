const mongoose = require('mongoose');
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
var Catagory = mongoose.model("Catagory",catagorySchema);

module.exports = Catagory;