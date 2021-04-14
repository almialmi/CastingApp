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