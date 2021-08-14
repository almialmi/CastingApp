const Category = require('../models/catagory.models');
const Request = require('../models/request.models');
const ComputationPost = require('../models/computationPost.models');
const User = require('../models/user.models');
const multer = require('multer');
const fs = require('fs');
const path = require('path');

global.__basedir = __dirname;

//multer upload storage
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, './categoryPhotoStorage/')
    },
    filename: (req, file, cb) => {
        cb(null, file.fieldname + "-" + Date.now() + "-" + file.originalname)
    }

});

const uploadStorage = multer({storage:storage,
    limits:{
        fileSize:1024*1024*5
    },
    fileFilter : function(req, file, callback) { //file filter
    if (['png','jpg','gif','jepg'].indexOf(file.originalname.split('.')[file.originalname.split('.').length-1]) === -1) {
        return callback(new Error('Wrong extension type'));
    }
    callback(null, true);
}}).single('photo');


module.exports.registerCategory =(req,res,next)=>{
    uploadStorage(req, res, (err) => {
        if(err){
           if(err.code === "LIMIT_UNEXPECTED_FILE"){
                return res.send("Too many image to upload.");
            }else{
                res.send(err)
            }
        } else {
            if(req.file == undefined){

                res.status(404).json({ success: false, msg: 'File is undefined!',file: `categoryPhotoStorage/${req.file}`})

            } else {
                
                var filepath= path.resolve('./categoryPhotoStorage/' + req.file.filename);
                
                var category = new Category();
                category.name = req.body.name;
                category.photo= req.file.path;

                category.save((err,doc)=>{
                    if(!err)
                      res.status(201).send({
                          message:"Category create successfully!!"
                      });
                    else{
                        fs.unlink(filepath)
                        if(err)
                           res.status(422).send(err);
                        else
                           return next(err);    
                    }
            
    });

 }}});
}

module.exports.showCategory =(req,res)=>{
    Category.find({__v:0})
            .sort({$natural:-1})
            .exec()
            .then((err,result)=>{
                if(err){
                    res.send(err)
                }else{
                    res.send(result)
                }
            })
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

module.exports.upadteCategotyProfilePicOrBoth= (req,res)=>{
        uploadStorage(req, res, (err) => {
            if(err){
                if(err.code === "LIMIT_UNEXPECTED_FILE"){
                    return res.send("Too many image to upload.");
                }else{
                    res.send(err)
                }
            } else {
                if(req.file == undefined){
    
                    res.status(404).json({ success: false, msg: 'File is undefined!',file: `categoryPhotoStorage/${req.file}`});
    
                } 
                else {
                  
                    var filepath= path.resolve('./categoryPhotoStorage/' + req.file.filename);
                      
                    if(!req.body.name){
                        Category.findByIdAndUpdate(req.params.id,{
                            $set:{
                                photo:req.file.path
                            }
                        }, {new: true})
                        .then(cat => {
                            if(!cat) {
                                fs.unlink(filepath)
                                return res.status(404).send({
                                    message: " Category not found with this " + req.params.id
                                });
                            }
                            res.send({
                                   message:"Category profile pic Update Successfully !!"
                            });
                        }).catch(err => {
                            fs.unlink(filepath)
                            if(err.kind === 'ObjectId') {
                                return res.status(404).send({
                                    message: "Category not found with this " + req.params.id
                                });                
                            }
                            return res.status(500).send({
                                message: "Error updating Category with id " + req.params.id
                            });
                      });

                    }else{
                        Category.findByIdAndUpdate(req.params.id,{
                            $set:{
                                name:req.body.name,
                                photo:req.file.path
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

                    }
    
     }}});   
}


module.exports.deleteCategory= async(req,res)=>{
    try{
        Category.findById(req.params.id, async function(err,cat){
            if(err){
                return res.status(400).send({
                    message: "Bad Request"
                });
            }else{
                if(cat == null){
                    return res.status(404).send({
                        message: "Category not found"
                    });
                }
                const user = await User.findOne({category: cat.id});
                if(user != null){
                    Request.remove({requestedUser:user.id}).exec();
                    ComputationPost.remove({user:user.id}).exec();
                    cat.remove();
                    res.send({message: "Category deleted successfully!"});
                }else{
                    cat.remove();
                    res.send({message: "Category deleted successfully!"});
    
                }   
            }
        })

    }catch(error){
        console.log(error)
    }
    

}
