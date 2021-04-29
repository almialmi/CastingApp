const mongoose = require('mongoose');
const Category = require('../models/catagory.models');
const multer = require('multer');

global.__basedir = __dirname;

//multer upload storage
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, __basedir + '/categoryPhotoStorage/')
    },
    filename: (req, file, cb) => {
        cb(null, file.fieldname + "-" + Date.now() + "-" + file.originalname)
    }

});

const uploadStorage = multer({storage:storage,
    fileFilter : function(req, file, callback) { //file filter
    if (['png'].indexOf(file.originalname.split('.')[file.originalname.split('.').length-1]) === -1) {
        return callback(new Error('Wrong extension type'));
    }
    callback(null, true);
}}).single('photo');


module.exports.registerCategory =(req,res,next)=>{
    uploadStorage(req, res, (err) => {
        if(err){
            console.log(err)
        } else {
            
            //console.log(req.file.filename);

            if(req.file == undefined){

                res.status(404).json({ success: false, msg: 'File is undefined!',file: `categoryPhotoStorage/${req.file}`})

            } else {
               var category = new Category();
                category.name = req.body.name;
                category.photo.data = req.file.filename;
                category.photo.contentType='image/png';

                category.save((err,doc)=>{
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
    uploadStorage(req, res, (err) => {
        if(err){
            console.log(err)
        } else {
            if(req.file == undefined){

                res.status(404).json({ success: false, msg: 'File is undefined!',file: `categoryPhotoStorage/${req.file}`});

            }
            else if (!req.body.name){
                return res.status(400).send({
                    message:"Name content cann't be empty"
                });
            }
            
            else {
                Category.findByIdAndUpdate(req.params.id,{
                    $set:{
                        name:req.body.name,
                        photo:{data:req.file.filename,contentType:'image/png'}
                    }
                }, {new: true})
                .then(cat => {
                    if(!cat) {
                        return res.status(404).send({
                            message: " Category not found with this " + req.params.id
                        });
                    }
                    res.send({
                           message:"Category Update Successfully !!"
                    });
                }).catch(err => {
                    if(err.kind === 'ObjectId') {
                        return res.status(404).send({
                            message: "Category not found with this " + req.params.id
                        });                
                    }
                    return res.status(500).send({
                        message: "Error updating Category with id " + req.params.id
                    });
              });

 }}});
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