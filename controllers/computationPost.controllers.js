const ComputationPost = require('../models/computationPost.models');


module.exports.addComputationPost =(req,res,next)=>{
    var post = new ComputationPost({
        user:req.body.user,
        eventForComputation:req.body.eventForComputation,
        video:req.body.video
    });
    post.save((err,cat)=>{
        if(!err)
            res.status(201).send(cat);
        else{
            if(err)
                res.status(422).send(err);
            else
                return next(err);    
        }
            
    });
   
}
module.exports.showComputationPosts=async(req,res)=>{
    try {
        let page = parseInt(req.query.page);
        let limit = parseInt(req.query.size);
       
        const offset = page ? page * limit : 0;
    
        console.log("offset = " + offset);    
    
        let result = {};
        let numOfStaffs;

        
        numOfStaffs = await ComputationPost.countDocuments({});
        result = await ComputationPost.find({__v:0}) 
                              .populate('user')
                              .populate('eventForComputation')
                              .skip(offset) 
                              .limit(limit); 
          
        const response = {
          "totalItems": numOfStaffs,
          "totalPages": Math.ceil(result.length / limit),
          "pageNumber": page,
          "pageSize": result.length,
          "COmputationPosts": result
        };
    
        res.status(200).json(response);
      } catch (error) {
        res.status(500).send({
          message: "Error -> Can NOT complete a paging request!",
          error: error.message,
        });
      }
     
}


module.exports.updateNumberOfLikes = async(req,res)=>{
    ComputationPost.findOne({_id:req.params.id},(err,comp)=>{
        if(err){
            res.send({error:err})
        }else{
             if(comp.like.indexOf(req.body.like) !== -1){
                 console.log('exist')
                 ComputationPost.findByIdAndUpdate(req.params.id,{
                     $pull:{
                         like:req.body.like
                     }
                 },{new:true}).exec((err,result)=>{
                     if(err){
                         return res.status(422).json({error:err})
                     }
                     else{
                         res.send({
                             nomberOfLike : result.like.length
                         })
                     }
                 })
 
             }else{
                 ComputationPost.findByIdAndUpdate(req.params.id,{
                     $push:{
                         like:req.body.like
                     }
                 },{new:true}).exec((err,result)=>{
                     if(err){
                         return res.status(422).json({error:err})
                     }
                     else{
                         res.send({
                             nomberOfLike : result.like.length
                         })
                     }
                 })
         }
            
        }
 
 
     })
    

}
//update number of dis like
module.exports.updateNumberOfDisLikes = async(req,res)=>{
    ComputationPost.findOne({_id:req.params.id},(err,comp)=>{
        if(err){
            res.send({error:err})
        }else{
             if(comp.disLike.indexOf(req.body.disLike) !== -1){
                 console.log('exist')
                 ComputationPost.findByIdAndUpdate(req.params.id,{
                     $pull:{
                        disLike:req.body.disLike
                     }
                 },{new:true}).exec((err,result)=>{
                     if(err){
                         return res.status(422).json({error:err})
                     }
                     else{
                         res.send({
                             nomberOfDislike : result.disLike.length
                         })
                     }
                 })
 
             }else{
                 ComputationPost.findByIdAndUpdate(req.params.id,{
                     $push:{
                        disLike:req.body.disLike
                     }
                 },{new:true}).exec((err,result)=>{
                     if(err){
                         return res.status(422).json({error:err})
                     }
                     else{
                         res.send({
                             nomberOfDisike : result.disLike.length
                         })
                     }
                 })
         }
            
        }
 })
    

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
            message:"point update:" + " " + req.body.jugePoints,
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
                   .populate('user')
                   .populate('eventForComputation')
                   .exec((err,result)=>{
                        if(err){
                             res.send(err)
                        }else{
                             res.status(200).send({
                                 message:result
                             })
                    }
 });    
}

module.exports.notifyBestThreeWinners =(req,res)=>{
    const sort = { like:-1,jugePoints:-1};
    const limit = 3;
    ComputationPost.find()
                   .sort(sort)
                   .populate('user')
                   .populate('eventForComputation')
                   .limit(limit)
                   .exec((err,result)=>{
                        if(err){
                             res.send(err)
                        }else{
                             res.status(200).send({
                                 message:result
                             })
                    }
 });   

}

