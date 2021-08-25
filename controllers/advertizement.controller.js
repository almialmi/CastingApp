const { read } = require('fs');
const Advertizement = require('../models/advertizement.models');


module.exports.createAdvertizement =(req,res,next)=>{
    var advert = new Advertizement({
        topic:req.body.topic,
        description:req.body.description
    });
    advert.save((err,advert)=>{
        if(!err)
            res.status(201).send({
                message:"Advert created successfully!!"
            });
        else{
            if(err)
                res.status(422).send(err);
            else
                return next(err);    
        }
            
    });
   
}

module.exports.showAdvertizement=async(req,res)=>{
    try {
        let page = parseInt(req.query.page);
        let limit = parseInt(req.query.size);
       
       
        const offset = page ? page * limit : 0;
    
        console.log("offset = " + offset);    
    
        let result = {};
        let numOfAdverts;
        let status = req.params.status
        
        numOfAdverts = await Advertizement.countDocuments({});
        result = await Advertizement.find({status:status},{__v:0}) 
                              .skip(offset) 
                              .limit(limit)
                              .sort({$natural:-1}); 
        
        
        const response = {
          "totalItems": numOfAdverts,
          "totalPages": Math.ceil(result.length / limit),
          "pageNumber": page,
          "pageSize": result.length,
          "Adverts": result
        };
    
        res.status(200).json(response);
      } catch (error) {
        res.status(500).send({
          message: "Error -> Can NOT complete a paging request!",
          error: error.message,
        });
      }
     
}


module.exports.deleteAdveritizment =(req,res)=>{
    Advertizement.findByIdAndRemove(req.params.id)
    .then(advert => {
        if(!advert) {
            return res.status(404).send({
                message: "Advert not found with id " + req.params.id
            });
        }
        res.send({message: "Advert deleted successfully!"});
    }).catch(err => {
        if(err.kind === 'ObjectId' || err.name === 'NotFound') {
            return res.status(404).send({
                message: "Advert found with id " + req.params.id
            });                
        }
        return res.status(500).send({
            message: "Could not delete Advert with id " + req.params.id
        });
    });

}

module.exports.updateAdvertizement = (req,res)=>{
    if(!req.body.description && !req.body.status){
        Advertizement.findByIdAndUpdate(req.params.id,{
            $set:{
                topic:req.body.topic
            }
        }, {new: true})
        .then(advert => {
            if(!advert) {
                return res.status(404).send({
                    message: "Advert not found with this " + req.params.id
                });
            }
            res.send({
                   message:"Advert Topic Update Successfully !!"
            });
        }).catch(err => {
            if(err.kind === 'ObjectId') {
                return res.status(404).send({
                    message: "Advert not found with this " + req.params.id
                });                
            }
            return res.status(500).send({
                message: "Error updating Advert profile with id " + req.params.id
            });
      });


    }
    else if(!req.body.topic && !req.body.status){
        Advertizement.findByIdAndUpdate(req.params.id,{
            $set:{
                description:req.body.description
            }
        }, {new: true})
        .then(advert => {
            if(!advert) {
                return res.status(404).send({
                    message: "Advert not found with this " + req.params.id
                });
            }
            res.send({
                   message:"Advert Description Update Successfully !!"
            });
        }).catch(err => {
            if(err.kind === 'ObjectId') {
                return res.status(404).send({
                    message: "Advert not found with this " + req.params.id
                });                
            }
            return res.status(500).send({
                message: "Error updating Advert profile with id " + req.params.id
            });
      });

    }
    else if(!req.body.topic && !req.body.description){
        Advertizement.findByIdAndUpdate(req.params.id,{
            $set:{
                status:req.body.status
            }
        }, {new: true})
        .then(advert => {
            if(!advert) {
                return res.status(404).send({
                    message: "Advert not found with this " + req.params.id
                });
            }
            res.send({
                   message:"Advert Status Update Successfully !!"
            });
        }).catch(err => {
            if(err.kind === 'ObjectId') {
                return res.status(404).send({
                    message: "Advert not found with this " + req.params.id
                });                
            }
            return res.status(500).send({
                message: "Error updating Advert profile with id " + req.params.id
            });
      });

    }
    else{
        Advertizement.findByIdAndUpdate(req.params.id,{
            $set:{
                topic:req.body.topic,
                description:req.body.description,
                status:req.body.status
            }
        }, {new: true})
        .then(advert => {
            if(!advert) {
                return res.status(404).send({
                    message: "Advert not found with this " + req.params.id
                });
            }
            res.send({
                   message:"Advert Update Successfully !!"
            });
        }).catch(err => {
            if(err.kind === 'ObjectId') {
                return res.status(404).send({
                    message: "Advert not found with this " + req.params.id
                });                
            }
            return res.status(500).send({
                message: "Error updating Advert profile with id " + req.params.id
            });
      });

    }
   
}
