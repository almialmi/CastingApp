const mongoose = require('mongoose');

mongoose.connect(process.env.MONGODB_URI,{
    useCreateIndex:true,
    useNewUrlParser:true,
    useUnifiedTopology:true,
    useFindAndModify:false
},(err)=>{
    if(!err){
        console.log('MongoDB connection successfully!!');
    }else{
        console.log('Error in MongoDB Connection:'+JSON.stringify(err,undefined,2));
    }
});

require('../models/admin.models');
require('../models/catagory.models');
require('../models/computationPost.models');
require('../models/event.models');
require('../models/user.models');
require('../models/request.models');