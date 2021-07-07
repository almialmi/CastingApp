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
            //console.log(err)
           if(err.code === "LIMIT_UNEXPECTED_FILE"){
                return res.send("Too many image to upload.");
            }
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
                      res.status(201).send({
                          message:"create successfully!!"
                      });
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
module.exports.updateCatagoryProfile = (req,res)=>{
    Category.findByIdAndUpdate(req.params.id,{
        $set:{
            name:req.body.name
        }
    }, {new: true})
    .then(cat => {
        if(!cat) {
            return res.status(404).send({
                message: "Catagory not found with this " + req.params.id
            });
        }
        res.send({
               message:"Catagory Name Update Successfully !!"
        });
    }).catch(err => {
        if(err.kind === 'ObjectId') {
            return res.status(404).send({
                message: "Catagory not found with this " + req.params.id
            });                
        }
        return res.status(500).send({
            message: "Error updating Category profile with id " + req.params.id
        });
  });
}

module.exports.upadteCategotyProfilePic= (req,res)=>{
    uploadStorage(req, res, (err) => {
        if(err){
            //console.log(err)
            if(err.code === "LIMIT_UNEXPECTED_FILE"){
                return res.send("Too many image to upload.");
            }
        } else {
            if(req.file == undefined){

                res.status(404).json({ success: false, msg: 'File is undefined!',file: `categoryPhotoStorage/${req.file}`});

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
  
    Category.findById(req.params.id,function(err,cat){
        if(err){
            return res.status(404).send({
                message: "Category not found"
            });
        }else{
            cat.remove();
            res.send({message: "Category deleted successfully!"});
        }
    })
    //fs.unlinkSync(filepath);

}
