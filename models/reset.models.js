const mongoose = require('mongoose');


const resetSchema = new mongoose.Schema({
_userId: {
     type: mongoose.Schema.Types.ObjectId, 
     required: true, 
     ref: 'Admin' 
    },
resettoken: { 
    type: String, 
    required: true 
},
createdAt: { 
    type: Date, 
    required: true, 
    default: Date.now, 
    expires: 1000000 
}
});

const Reset = mongoose.model('Reset', resetSchema);

module.exports = Reset;