const User = require('../models/user.models');
const multer = require('multer');
const fs = require('fs');
const path = require('path');
const emailValidator = require('deep-email-validator');
const validator =require('validator');
const jwt = require('jsonwebtoken');





async function isEmailValid(email) {
    return emailValidator.validate(email)
}
//multer upload storage
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, './usersPhotoStorage/')
    },
    filename: (req, file, cb) => {
        cb(null, file.fieldname + "-" + Date.now() + "-" + file.originalname)
    }

});

const uploadStorage = multer({storage:storage,
    limits:{
        fileSize:1024*1024*20
    },
    fileFilter : function(req, file, callback) { //file filter
    if (['png','jpg','gif','jepg'].indexOf(file.originalname.split('.')[file.originalname.split('.').length-1]) === -1) {
        return callback(new Error('Wrong extension type'));
    }
    callback(null, true);
}}).array('photos',3);



module.exports.userRegister = (req,res)=>{
    uploadStorage(req, res, async(err) => {
        if(err){
           // console.log(err)
            if(err.code === "LIMIT_UNEXPECTED_FILE"){
                return res.send("Too many image to upload.");
            }
        } 
        else {
               let formatedphone = 0;
                let phone = req.body.mobile;
                if (phone.charAt(0) == '0') {
                    formatedphone = '+251' + phone.substring(1);
                } else if ((phone.charAt(0) == '+') && (phone.length > 12 || phone.length <= 13)) {
                    formatedphone = phone
                }
                if(req.files == undefined){

                    res.status(404).json({ success: false, msg: 'File is undefined!',file: `usersPhotoStorage/${req.files}`})

                } 
                else if (req.files.length < 3) {
                    return res.send("Must upload 4 photos");
                
                }else {

                function unlinkImage(n){
                    for(let i=0;i<n;i++){ 
                        var filepath= path.resolve('./usersPhotoStorage/' + req.files[i].filename);
                        fs.unlink(filepath,function(err,result){
                            console.log(err);
                        });
                    }
                        
                } 
               
                var user = new User();
                user.firstName = req.body.firstName;
                user.lastName = req.body.lastName;
                user.email = req.body.email;
                user.mobile = formatedphone;
                user.category = req.body.category;
                user.video = req.body.video;
                user.gender = req.body.gender;
                user.photo1 = req.files[0].path;
                user.photo2= req.files[1].path;
                user.photo3 = req.files[2].path;

                user.save((err,doc)=>{
                        if(!err)
                        res.status(201).send({
                            message:"Register Successfully"
                        });
                        else{
                            if(err){
                            unlinkImage(req.files.length)
                            res.status(422).send(err);
                            }else{
                                return next(err); 

                            }}});
                        }
       }
});
}

module.exports.fetchAllUser = async(req,res)=>{
    try {
        let page = parseInt(req.query.page);
        let limit = parseInt(req.query.size);
       
        const offset = page ? page * limit : 0;
    
        console.log("offset = " + offset);    
    
        let result = {};
        let numOfStaffs;
        
        numOfStaffs = await User.countDocuments({});
        result = await User.find({__v:0}) 
                              .populate('category',{name:1})
                              .skip(offset) 
                              .limit(limit)
                              .sort({$natural:-1}); 
          
        const response = {
          "totalItems": numOfStaffs,
          "totalPages": Math.ceil(result.length / limit),
          "pageNumber": page,
          "pageSize": result.length,
          "post": result
        };
    
        res.status(200).json(response);
      } catch (error) {
        res.status(500).send({
          message: "Error -> Can NOT complete a paging request!",
          error: error.message,
        });
      }
     
}

//update but some issue 

module.exports.updateUserProfile = async(req,res)=>{
    if (!req.body.lastName && !req.body.email && !req.body.mobile && !req.body.video && !req.body.category && !req.body.gender){
        User.findByIdAndUpdate(req.params.id,{
            $set:{
                firstName:req.body.firstName
            }
        }, {new: true})
        .then(user => {
            if(!user) {
                return res.status(404).send({
                    message: "User not found with this " + req.params.id
                });
            }
            res.send({
                   message:"User firstName Update Successfully !!"
            });
        }).catch(err => {
            if(err.kind === 'ObjectId') {
                return res.status(404).send({
                    message: "User not found with this " + req.params.id
                });                
            }
            return res.status(500).send({
                message: "Error updating User profile with id " + req.params.id
            });
      });
    }
    else if(!req.body.firstName && !req.body.email && !req.body.mobile && !req.body.video && !req.body.category && !req.body.gender){
        
        User.findByIdAndUpdate(req.params.id,{
            $set:{
                lastName:req.body.lastName
            }
        }, {new: true})
        .then(user => {
            if(!user) {
                return res.status(404).send({
                    message: "User not found with this " + req.params.id
                });
            }
            res.send({
                   message:"User lastName Update Successfully !!"
            });
        }).catch(err => {
            if(err.kind === 'ObjectId') {
                return res.status(404).send({
                    message: "User not found with this " + req.params.id
                });                
            }
            return res.status(500).send({
                message: "Error updating User profile with id " + req.params.id
            });
      });
    }
    else if(!req.body.firstName && !req.body.lastName && !req.body.mobile && !req.body.video && !req.body.category && !req.body.gender){
        const {valid, reason, validators} = await isEmailValid(req.body.email);
        if(valid){   
            User.findByIdAndUpdate(id,{
                $set:{
                    email:req.body.email
                }
            }, {new: true})
            .then(user => {
                if(!user) {
                    return res.status(404).send({
                        message: "User not found with this " + id
                    });
                }
                res.send({
                       message:"User Email Update Successfully !!"
                });
            }).catch(err => {
                if(err.kind === 'ObjectId') {
                    return res.status(404).send({
                        message: "User not found with this " + id
                    });                
                }
                return res.status(500).send({
                    message: "Error updating User profile with id " + id
                });
          });
    
        }else{
            return res.status(400).send({
                message: "Please provide a valid email address.",
                reason: validators[reason].reason
            })
        }
    }
    else if(!req.body.firstName && !req.body.lastName && !req.body.email && !req.body.video && !req.body.category && !req.body.gender){
        let formatedphone = '';
        let phone = req.body.mobile;
        if (phone.charAt(0) == '0') {
            formatedphone = '+251' + phone.substring(1);
        } else if ((phone.charAt(0) == '+') && (phone.length > 12 || phone.length <= 13)) {
            formatedphone = phone
        }
        User.findByIdAndUpdate(req.params.id,{
            $set:{
                mobile:formatedphone,
            }
        }, {new: true})
        .then(user => {
            if(!user) {
                return res.status(404).send({
                    message: "User not found with this " + req.params.id
                });
            }
            res.send({
                    message:"User mobile Update Successfully !!"
            });
        }).catch(err => {
            if(err.kind === 'ObjectId') {
                return res.status(404).send({
                    message: "User not found with this " + req.params.id
                });                
            }
            return res.status(500).send({
                message: "Error updating User profile with id " + req.params.id
            });
        });
    }
    else if(!req.body.firstName && !req.body.lastName && !req.body.email && ! req.body.mobile && !req.body.category && !req.body.gender){
        
        User.findByIdAndUpdate(req.params.id,{
            $set:{
                video:req.body.video
            }
        }, {new: true})
        .then(user => {
            if(!user) {
                return res.status(404).send({
                    message: "User not found with this " + req.params.id
                });
            }
            res.send({
                   message:"User Video Update Successfully !!"
            });
        }).catch(err => {
            if(err.kind === 'ObjectId') {
                return res.status(404).send({
                    message: "User not found with this " + req.params.id
                });                
            }
            return res.status(500).send({
                message: "Error updating User profile with id " + req.params.id
            });
      });

    }
    else if(!req.body.firstName && !req.body.lastName && !req.body.email && ! req.body.mobile && !req.body.video && !req.body.gender){
        
        User.findByIdAndUpdate(req.params.id,{
            $set:{
                category:req.body.category
            }
        }, {new: true})
        .then(user => {
            if(!user) {
                return res.status(404).send({
                    message: "User not found with this " + req.params.id
                });
            }
            res.send({
                   message:"User Category Update Successfully !!"
            });
        }).catch(err => {
            if(err.kind === 'ObjectId') {
                return res.status(404).send({
                    message: "User not found with this " + req.params.id
                });                
            }
            return res.status(500).send({
                message: "Error updating User profile with id " + req.params.id
            });
      });
    }
    else if(!req.body.firstName && !req.body.lastName && !req.body.email && ! req.body.mobile && !req.body.category && !req.body.video){
        User.findByIdAndUpdate(req.params.id,{
            $set:{
                gender:req.body.gender
            }
        }, {new: true})
        .then(user => {
            if(!user) {
                return res.status(404).send({
                    message: "User not found with this " + req.params.id
                });
            }
            res.send({
                   message:"User gender Update Successfully !!"
            });
        }).catch(err => {
            if(err.kind === 'ObjectId') {
                return res.status(404).send({
                    message: "User not found with this " + req.params.id
                });                
            }
            return res.status(500).send({
                message: "Error updating User profile with id " + req.params.id
            });
      });
    }else{
        let formatedphone = '';
        let phone = req.body.mobile;
        if (phone.charAt(0) == '0') {
            formatedphone = '+251' + phone.substring(1);
        } else if ((phone.charAt(0) == '+') && (phone.length > 12 || phone.length <= 13)) {
            formatedphone = phone
        }
        User.findByIdAndUpdate(req.params.id,{
            $set:{
                 firstName: req.body.firstName,
                 lastName : req.body.lastName,
                 email : req.body.email,
                 mobile : formatedphone,
                 category: req.body.category,
                 video : req.body.video,
                 gender : req.body.gender
            }
        }, {new: true})
        .then(user => {
            if(!user) {
                return res.status(404).send({
                    message: "User not found with this " + req.params.id
                });
            }
            res.send({
                   message:"User Update Successfully !!"
            });
        }).catch(err => {
            if(err.kind === 'ObjectId') {
                return res.status(404).send({
                    message: "User not found with this " + req.params.id
                });                
            }
            return res.status(500).send({
                message: "Error updating User profile with id " + req.params.id
            });
      });

    }
}

module.exports.deleteUser= (req,res)=>{
   // var filepath= path.resolve(__basedir ,'./usersPhotoStorage/' + req.params.files); 
  try{
    User.findById(req.params.id,function(err,user){
        if(err){
            return res.status(404).send({
                message: "Bad Request"
            });
        }else{
            if(user == null){
                return res.status(404).send({
                    message: "User not found"
                });
            }
            user.remove();
            res.send({message: "User deleted successfully!"});
        }
    })
  }catch(error){
      console.log(error)
  }

 //   fs.unlinkSync(filepath);

}

module.exports.updateLike =(req,res)=>{
   User.findOne({_id:req.params.id},(err,user)=>{
       if(err){
           res.send({error:err})
       }else{
           if(!user){
               res.send({
                   message:"User not found"
               })
           }else{
            if(user.disLike.indexOf(req.body.id) !== -1){
                User.findByIdAndUpdate(req.params.id,{
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
            else if(user.like.indexOf(req.body.id) !== -1){
                console.log('exist')
                User.findByIdAndUpdate(req.params.id,{
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
                User.findByIdAndUpdate(req.params.id,{
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
       
    }
    })
}

module.exports.updateDisLike =(req,res)=>{
    
    User.findOne({_id:req.params.id},(err,user)=>{
        if(err){
            res.send({error:err})
        }else{
            if(!user){
                res.send({
                    message:"User not found"
                })
            }else{
                if(user.like.indexOf(req.body.id) !== -1){
                    User.findByIdAndUpdate(req.params.id,{
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
                else if(user.disLike.indexOf(req.body.id)!== -1){
                     console.log('exist')
                     User.findByIdAndUpdate(req.params.id,{
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
                     User.findByIdAndUpdate(req.params.id,{
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
        }
 })

}

//fetch user based on category and gender
// male user and female user 
module.exports.fetchUserMaleAndFemale= async(req,res)=>{
    try {
       let page = parseInt(req.query.page);
       let limit = parseInt(req.query.size);
      
       const offset = page ? page * limit : 0;
   
       console.log("offset = " + offset);    
   
       let result = {};
       let numOfStaffs;
       let category = req.params.category;
       let gender = req.params.gender;
       //console.log(category);

       
       numOfStaffs = await User.countDocuments({});
       result = await User.find({category:category,gender:gender},{__v:0}) 
                             .populate('category',{name:1})
                             .skip(offset) 
                             .limit(limit)
                             .sort({$natural:-1}); 
         
       const response = {
         "totalItems": numOfStaffs,
         "totalPages": Math.ceil(result.length / limit),
         "pageNumber": page,
         "pageSize": result.length,
         "post": result
       };
   
       res.status(200).json(response);
     } catch (error) {
       res.status(500).send({
         message: "Error -> Can NOT complete a paging request!",
         error: error.message,
       });
     }
    

}







