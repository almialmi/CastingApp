const EventForComputation = require('../models/event.models');
const multer = require('multer');
const fs = require('fs');


global.__basedir = __dirname;

//multer upload storage
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, __basedir + '/eventPhotoStorage/')
    },
    filename: (req, file, cb) => {
        cb(null, file.fieldname + "-" + Date.now() + "-" + file.originalname)
    }

});

const uploadStorage = multer({storage:storage,
    fileFilter : function(req, file, callback) { //file filter
    if (['png','jpg','gif','jepg'].indexOf(file.originalname.split('.')[file.originalname.split('.').length-1]) === -1) {
        return callback(new Error('Wrong extension type'));
    }
    callback(null, true);
}}).single('photo');

module.exports.registerEvent =(req,res,next)=>{
    uploadStorage(req, res, (err) => {
        if(err){
            console.log(err)
        } else {
            
            //console.log(req.file.filename);

            if(req.file == undefined){

                res.status(404).json({ success: false, msg: 'File is undefined!',file: `eventPhotoStorage/${req.file}`})

            } else {
               var startDate = new Date(req.body.startDate);
               var endDate = new Date(req.body.endDate); 
               var eventForCOmputation = new EventForComputation();
               eventForCOmputation.name = req.body.name;
               eventForCOmputation.description = req.body.description;
               eventForCOmputation.category = req.body.category;
               eventForCOmputation.photo.data = req.file.filename;
               eventForCOmputation.photo.contentType='image/png';
               eventForCOmputation.startDate = startDate;
               eventForCOmputation.endDate = endDate;

               eventForCOmputation.save((err,doc)=>{
                    if(!err)
                      res.status(201).send(doc);
                    else{
                        if(err)
                           res.status(422).send(err);
                        else
                           return next(err);    
                    }
            
    });

 }}});
}

module.exports.showEvents=(req,res)=>{
    EventForComputation.find({__v:0},(err,result)=>{
        if(err){
            res.send(err)
        }else{
            res.send(result)
        }
    });

}

module.exports.updateEvent =(req,res)=>{
    uploadStorage(req, res, (err) => {
        if(err){
            console.log(err)
        } else {
            if(req.file == undefined){

                res.status(404).json({ success: false, msg: 'File is undefined!',file: `eventPhotoStorage/${req.file}`});

            }
            else if (!req.body.name && !req.body.description && !req.body.category && !req.body.photo && !req.body.startDate && !req.body.endDate){
                return res.status(400).send({
                    message:"All this content cann't be empty"
                });
            }
            
            else {
                EventForComputation.findByIdAndUpdate(req.params.id,{
                    $set:{
                        name:req.body.name,
                        description:req.body.description,
                        category: req.body.category,
                        photo:{data:req.file.filename,contentType:'image/png'},
                        startDate : req.body.startDate,
                        endDate :req.body.endDate
                    }
                }, {new: true})
                .then(cat => {
                    if(!cat) {
                        return res.status(404).send({
                            message: " Event not found with this " + req.params.id
                        });
                    }
                    res.send({
                           message:"Event Update Successfully !!"
                    });
                }).catch(err => {
                    if(err.kind === 'ObjectId') {
                        return res.status(404).send({
                            message: "Event not found with this " + req.params.id
                        });                
                    }
                    return res.status(500).send({
                        message: "Error updating Event with id " + req.params.id
                    });
              });

 }}});

}
module.exports.deleteEvent=(req,res)=>{
   
    var filepath= path.resolve(__basedir, '/eventPhotoStorage/' + req.params.filename);  

    EventForComputation.findByIdAndRemove(req.params.id)
    .then(eve => {
        if(!eve) {
            return res.status(404).send({
                message: "Event not found with id " + req.params.id
            });
        }
        res.send({message: "Event deleted successfully!"});
    }).catch(err => {
        if(err.kind === 'ObjectId' || err.name === 'NotFound') {
            return res.status(404).send({
                message: "Event found with id " + req.params.id
            });                
        }
        return res.status(500).send({
            message: "Could not delete Event with id " + req.params.id
        });
    });

    fs.unlinkSync(filepath);

}

module.exports.showRemainingTimeAndExpried= (req,res)=>{
    
    EventForComputation.findById({_id:req.params.id},((err,data)=>{
        if(err) { 
            return res.send(err); 
        }
        else{
        var days,hours,minutes,seconds;
        var startDate = data.startDate;
        var endDate = data.endDate;
        var current = new Date().getTime();
        var deadline = new Date(endDate).getTime();
       // var startline = new Date(startDate).getTime();
        var remain = deadline - current;
        function intervalFunc(){
             days = Math.floor(remain/(1000*60*60*24));
             hours = Math.floor((remain % (1000*60*60*24))/(1000*60*60));
             minutes = Math.floor((remain %(1000*60*60))/(1000*60));
             seconds = Math.floor((remain%(1000*60))/1000);
        }
        intervalFunc();

    var interval = setInterval(intervalFunc,1000);
    if(remain < 0){
        clearInterval(interval)
        return res.status(200).send({
            message: "Event closed !!"
        });

    }else{
        interval;
        return res.status(200).send({
            message: "Remaing Time to Close :" + days + " " + "days" + " " + hours + " " + "hours" + " " + minutes + " " + "minutes" + " " + seconds + "seconds"

        });
        console.log(interval);
    }
    
}
}));
}




