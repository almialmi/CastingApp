const mongoose = require('mongoose');
var catagorySchema = new mongoose.Schema({
    name:{
        type:String,
        require:true
    }
});
var Catagory = mongoose.model("Catagory",catagorySchema);

module.exports = Catagory;