const EventForComputation = require('../models/event.models');
const multer = require('multer');
const fs = require('fs');
const path = require('path');


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
              
              function unlinkImage(){
                var filepath= path.resolve(__basedir ,'./eventPhotoStorage/' + req.file.filename);
                fs.unlink(filepath,function(err,result){
                    console.log(err);
                });
              }

               var newImg = fs.readFileSync(req.file.path);
               var encImg = newImg.toString('base64');
               var startDate = new Date(req.body.startDate);
               var endDate = new Date(req.body.endDate); 

               var eventForCOmputation = new EventForComputation();
               eventForCOmputation.name = req.body.name;
               eventForCOmputation.description = req.body.description;
               eventForCOmputation.category = req.body.category;
               eventForCOmputation.photo.data = Buffer.from(encImg, 'base64');
               eventForCOmputation.photo.contentType='image/png';
               eventForCOmputation.startDate = startDate;
               eventForCOmputation.endDate = endDate;

               eventForCOmputation.save((err,doc)=>{
                    if(!err)
                      res.status(201).send(doc);
                    else{
                        unlinkImage()
                        if(err)
                           res.status(422).send(err);
                        else
                           return next(err);    
                    }
            
    });

 }}});
}

//show events that are closed and panding
module.exports.showEvents= async(req,res)=>{
    try {
        
        let page = parseInt(req.query.page);
        let limit = parseInt(req.query.size);
       
        const offset = page ? page * limit : 0;
    
        console.log("offset = " + offset);    
    
        let result = {};
        let numOfStaffs;
        let closed = req.params.closed;
        
 
        
        numOfStaffs = await EventForComputation.countDocuments({});
        result = await EventForComputation.find({closed:closed},{__v:0}) 
                              .populate('category')
                              .skip(offset) 
                              .limit(limit); 
        
        const response = {
          "totalItems": numOfStaffs,
          "totalPages": Math.ceil(result.length / limit),
          "pageNumber": page,
          "pageSize": result.length,
          "Events": result
        };
    
        res.status(200).send(response);
      } catch (error) {
        res.status(500).send({
          message: "Error -> Can NOT complete a paging request!",
          error: error.message,
        });
      }

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
                function unlinkImage(){
                    var filepath= path.resolve(__basedir ,'./eventPhotoStorage/' + req.file.filename);
                    fs.unlink(filepath,function(err,result){
                        console.log(err);
                    });
                  }
    
                var newImg = fs.readFileSync(req.file.path);
                var encImg = newImg.toString('base64');
                EventForComputation.findByIdAndUpdate(req.params.id,{
                    $set:{
                        name:req.body.name,
                        description:req.body.description,
                        category: req.body.category,
                        photo:{
                            data:Buffer.from(encImg, 'base64'),
                            contentType:'image/png'
                        },
                        startDate : req.body.startDate,
                        endDate :req.body.endDate
                    }
                }, {new: true})
                .then(cat => {
                    if(!cat) {
                        unlinkImage()
                        return res.status(404).send({
                            message: " Event not found with this " + req.params.id
                        });
                    }
                    res.send({
                           message:"Event Update Successfully !!"
                    });
                }).catch(err => {
                    unlinkImage()
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
    //var filepath= path.resolve(__basedir ,'./eventPhotoStorage/' + req.params.filename);
    
    EventForComputation.findById(req.params.id,function(err,eve){
        if(err){
            return res.status(404).send({
                message: "Event not found"
            });
        }else{
            eve.remove();
            res.send({message: "Event deleted successfully!"});
        }
    })

  //  fs.unlinkSync(filepath);

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
        EventForComputation.findByIdAndUpdate(req.params.id,{
                $set:{
                    closed:true
                }  
            }, {new: true})
            .then(eve => {
                if(!eve) {
                    return res.status(404).send({
                        message: "Event not found with this " + req.params.id
                    });
                }
                res.send({
                        message:"Event is Closed !!"
                });
            }).catch(err => {
                if(err.kind === 'ObjectId') {
                    return res.status(404).send({
                        message: "Event not found with this " + req.params.id
                    });                
                }
                return res.status(500).send({
                    message: "Error closing the event with id " + req.params.id
                });
            });

    }else{
        interval;
        return res.status(200).send({
            message: "Remaing Time to Close :" + days + " " + "days" + " " + hours + " " + "hours" + " " + minutes + " " + "minutes" + " " + seconds + "seconds"

        });
    }
    
}
}));
}

module.exports.fetchImageEvent =(req,res)=>{

    EventForComputation.findById(req.params.id)
    .then(user => {
        res.setHeader('content-type',user.photo.contentType);
        res.send(user.photo.data);
    }).catch(err => {
        if(err.kind === 'ObjectId' || err.name === 'NotFound') {
            return res.status(404).send({
                message: "User found with id " + req.params.id
            });                
        }
        return res.status(500).send({
            message: "Could not delete User with id " + req.params.id
        });
    });

}




