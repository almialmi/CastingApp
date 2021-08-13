const ComputationPost = require('../models/computationPost.models');
const jwt = require('jsonwebtoken');

module.exports.addComputationPost =(req,res,next)=>{
    var post = new ComputationPost({
        user:req.body.user,
        eventForComputation:req.body.eventForComputation,
        video:req.body.video
    });
    post.save((err,cat)=>{
        if(!err)
            res.status(201).send({
                message:"Computational post created successfully!!"
            });
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
        let eventForComputation = req.params.eventForComputation;

        
        numOfStaffs = await ComputationPost.countDocuments({});
        result = await ComputationPost.find({eventForComputation:eventForComputation},{__v:0}) 
                              .populate('user',{firstName:1,lastName:1,mobile:1})
                              .populate('eventForComputation',{name:1,description:1})
                              .skip(offset) 
                              .limit(limit)
                              .sort({$natural:-1}); 
        
        
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
            if(comp.disLike.indexOf(req.body.id) !== -1){
                ComputationPost.findByIdAndUpdate(req.params.id,{
                    $pull:{
                        disLike:req.body.id
                    },
                    $push:{
                        like:req.body.id
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
            else if(comp.like.indexOf(req.body.id) !== -1){
                 console.log('exist')
                 ComputationPost.findByIdAndUpdate(req.params.id,{
                     $pull:{
                         like:req.body.id
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
                         like:req.body.id
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
            if(comp.like.indexOf(req.body.id) !== -1){
                ComputationPost.findByIdAndUpdate(req.params.id,{
                    $pull:{
                        like:req.body.id
                    },
                    $push:{
                        disLike:req.body.id
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

            }
            else if(comp.disLike.indexOf(req.body.id) !== -1){
                 console.log('exist')
                 ComputationPost.findByIdAndUpdate(req.params.id,{
                     $pull:{
                        disLike:req.body.id
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
                        disLike:req.body.id
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

module.exports.fillJugePoints = async(req,res)=>{
    const { id } = req.params.id
    const com = await ComputationPost.findOne({ id });
    let sumOfPoints = com.sumOfJugePoints + req.body.jugePoints  
    
    ComputationPost.findByIdAndUpdate(req.params.id,{
        $push:{
            jugePoints:req.body.jugePoints 
         },
         sumOfJugePoints:sumOfPoints

    },{new:true}).exec( async (err,result)=>{
        if(err){
            return res.status(422).json({error:err})
        }
        else{
            return res.send({
                 message: "set judges points!!"

            })
        }
    })
}


module.exports.orderByHighestLikeToTheEvent=(req,res)=>{
    let eventForComputation = req.params.eventForComputation;
    const sort = { sumOfJugesPoint:-1,like:-1};
    ComputationPost.find({eventForComputation:eventForComputation},{__v:0})
                   .sort(sort)
                   .populate('user',{firstName:1,lastName:1,mobile:1})
                   .populate('eventForComputation',{name:1,description:1})
                   .exec((err,result)=>{
                        if(err){
                             res.send(err)
                        }else{
                             res.status(200).send({
                                COmputationPosts:result
                             })
                    }
 });    
}

module.exports.notifyBestThreeWinners =(req,res)=>{
    let eventForComputation = req.params.eventForComputation;
    const sort = { sumOfJugesPoint:-1,like:-1};
    const limit = 3;
    ComputationPost.find({eventForComputation:eventForComputation},{__v:0})
                   .sort(sort)
                   .populate('user',{firstName:1,lastName:1,mobile:1})
                   .populate('eventForComputation',{name:1,description:1})
                   .limit(limit)
                   .exec((err,result)=>{
                        if(err){
                             res.send(err)
                        }else{
                             res.status(200).send({
                                ComputationPosts:result
                             })
                    }
 });   

}

