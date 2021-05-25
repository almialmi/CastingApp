const mongoose = require('mongoose');
const Category = require('../models/catagory.models');
const multer = require('multer');
const fs = require('fs');

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
    if (['png','jpg','gif','jepg'].indexOf(file.originalname.split('.')[file.originalname.split('.').length-1]) === -1) {
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
                function unlinkImage(){
                    var filepath= path.resolve(__basedir ,'./categoryPhotoStorage/' + req.file.filename);
                    fs.unlink(filepath,function(err,result){
                        console.log(err);
                    });
                  }
                var newImg = fs.readFileSync(req.file.path);
                var encImg = newImg.toString('base64');
                var category = new Category();
                category.name = req.body.name;
                category.photo.data = Buffer.from(encImg, 'base64');
                category.photo.contentType='image/png';

                category.save((err,doc)=>{
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
                function unlinkImage(){
                    var filepath= path.resolve(__basedir ,'./categoryPhotoStorage/' + req.file.filename);
                    fs.unlink(filepath,function(err,result){
                        console.log(err);
                    });
                  }
                var newImg = fs.readFileSync(req.file.path);
                var encImg = newImg.toString('base64');
                Category.findByIdAndUpdate(req.params.id,{
                    $set:{
                        name:req.body.name,
                        photo:{
                            data:Buffer.from(encImg, 'base64'),
                            contentType:'image/png'
                        }
                    }
                }, {new: true})
                .then(cat => {
                    if(!cat) {
                        unlinkImage()
                        return res.status(404).send({
                            message: " Category not found with this " + req.params.id
                        });
                    }
                    res.send({
                           message:"Category Update Successfully !!"
                    });
                }).catch(err => {
                    unlinkImage()
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
    //var filepath= path.resolve(__basedir ,'./categoryPhotoStorage/' + req.params.filename); 
  
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
    //fs.unlinkSync(filepath);

}