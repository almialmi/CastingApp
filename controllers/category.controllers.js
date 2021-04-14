const mongoose = require('mongoose');
const Category = require('../models/catagory.models');

module.exports.registerCategory =(req,res,next)=>{
    var category = new Category({
        name:req.body.name
    });
    category.save((err,cat)=>{
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

module.exports.showCategory =(req,res)=>{
    Category.find({__v:0},(err,result)=>{
        if(err){
            res.send(err)
        }else{
            res.send(result)
        }
    });
}

module.exports.upadteCategoty= (req,res)=>{
    if(!req.body.name) {
        return res.status(400).send({
            message: "name contents can not be empty"
        });
    }
    
     Category.findByIdAndUpdate(req.params.id, {
        $set:{
            name:req.body.name
        }
        
    }, {new: true})
    .then(cat => {
        if(!cat) {
            return res.status(404).send({
                message: "Category not found with id " + req.params.id
            });
        }
        res.status(200).send({
            message:"successfully update Category ",
            success:true
        });
    }).catch(err => {
        if(err.kind === 'ObjectId') {
            return res.status(404).send({
                message: "Catagory not found with id " + req.params.id
            });                
        }
        return res.status(500).send({
            message: "Error updating Category with id " + req.params.id
        });
    });
}

module.exports.deleteCategory=(req,res)=>{
    Category.findByIdAndRemove(req.params.id)
    .then(cat => {
        if(!cat) {
            return res.status(404).send({
                message: "Category not found with id " + req.params.id
            });
        }
        res.send({message: "Category deleted successfully!"});
    }).catch(err => {
        if(err.kind === 'ObjectId' || err.name === 'NotFound') {
            return res.status(404).send({
                message: "Category found with id " + req.params.id
            });                
        }
        return res.status(500).send({
            message: "Could not delete Category with id " + req.params.id
        });
    });

}