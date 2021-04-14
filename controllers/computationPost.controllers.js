const ComputationPost = require('../models/computationPost.models');
const multer = require('multer');
const EventForComputation = require('../models/event.models');
const { post } = require('../routes/index.route');

global.__basedir = __dirname;

//multer upload storage
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, __basedir + '/computationPostStorage/')
    },
    filename: (req, file, cb) => {
        cb(null, file.fieldname + "-" + Date.now() + "-" + file.originalname)
    }

});

const uploadStorage = multer({storage:storage,
    fileFilter : function(req, file, callback) { //file filter
    if (['mp4'].indexOf(file.originalname.split('.')[file.originalname.split('.').length-1]) === -1) {
        return callback(new Error('Wrong extension type'));
    }
    callback(null, true);
}}).single('video');


module.exports.addPost =(req,res,next)=>{
    uploadStorage(req, res, (err) => {
        if(err){
            console.log(err)
        } else {

            if(req.file == undefined){

                res.status(404).json({ success: false, msg: 'File is undefined!',file: `computationPostStorage/${req.file.filename}`})

            } else {
              
               // console.log(req.file.path);
               var computationPost = new ComputationPost();
                computationPost.user = req.body.user;
                computationPost.eventForComputation = req.body.eventForComputation;
                computationPost.like = req.body.like;
                computationPost.video.data=req.file.filename;
                computationPost.video.contentType='video/mp4';

                //console.log(__basedir + '/uploads/' + req.file.filename);
                computationPost.save((err,doc)=>{
                    //console.log(doc);
                    if(!err)
                      res.send(201,doc);
                    else{
                        if(err)
                           res.status(422).send(err);
                        else
                           return next(err);    
                    }
            
    });

 }}});

}
module.exports.showPosts=async(req,res)=>{
    ComputationPost.find({__v:0})
                   .populate('eventForComputation')
                   .populate('user')
                   .exec((err,result)=>{
                       if(err){
                          res.send(err)
                       }else{
                         res.send(result)
                     }
                });
}


module.exports.updateLikes = async(req,res)=>{
     console.log(req.body.like);
     const numberOfLike = req.body.like + 1; 
     console.log(numberOfLike);
     await ComputationPost.findByIdAndUpdate(req.params.id,{
       $set:{
          like:numberOfLike
 
       }  
     }, {new: true})
     .then(pos => {
         if(!pos) {
             return res.status(404).send({
                 message: "Post not found with this " + req.params.id
             });
         }
         res.send({
                message:"like increased by one"
         });
     }).catch(err => {
         if(err.kind === 'ObjectId') {
             return res.status(404).send({
                 message: "Post not found with this " + req.params.id
             });                
         }
         return res.status(500).send({
             message: "Error like this viedo with id " + req.params.id
         });
   });

}

module.exports.deletePost =(req,res)=>{
    ComputationPost.findByIdAndRemove(req.params.id)
    .then(post => {
        if(!post) {
            return res.status(404).send({
                message: "Post not found with id " + req.params.id
            });
        }
        res.send({message: "Post deleted successfully!"});
    }).catch(err => {
        if(err.kind === 'ObjectId' || err.name === 'NotFound') {
            return res.status(404).send({
                message: "Post found with id " + req.params.id
            });                
        }
        return res.status(500).send({
            message: "Could not delete post with id " + req.params.id
        });
    });

}

module.exports.fillJugePoints =(req,res)=>{
    if(!req.body.user && !req.body.eventForComputation && !req.body.video && !req.body.like) {
        return res.status(400).send({
            message: " All this contents cann't be empty"
        });
    }
    ComputationPost.findByIdAndUpdate(req.params.id, {
        $set:{
            jugePoints:req.body.jugePoints
        }
        
    }, {new: true})
    .then(post => {
        if(!post) {
            return res.status(404).send({
                message: "Post not found with id " + req.params.id
            });
        }
        res.status(200).send({
            message:"successfully update post",
            success:true
        });
    }).catch(err => {
        if(err.kind === 'ObjectId') {
            return res.status(404).send({
                message: "post not found with id " + req.params.id
            });                
        }
        return res.status(500).send({
            message: "Error updating post with id " + req.params.id
        });
    });


}

module.exports.orderByHighestLikeToTheEvent=(req,res)=>{
    const sort = { like:-1,jugePoints:-1};
    ComputationPost.find()
                   .sort(sort)
                   .toArray((err,result)=>{
                        if(err){
                             res.send(err)
                        }else{
                             res.send(result)
                    }
 });    
}

module.exports.notifyBestThreeWinners =(req,res)=>{
    const sort = { like:-1,jugePoints:-1};
    const limit = 3;
    ComputationPost.find()
                   .sort(sort)
                   .limit(limit)
                   .toArray((err,result)=>{
                        if(err){
                             res.send(err)
                        }else{
                             res.send(result)
                    }
 });   

}

