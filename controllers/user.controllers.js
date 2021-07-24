const User = require('../models/user.models');
const multer = require('multer');
const fs = require('fs');
const path = require('path');

const validator =require('validator');


global.__basedir = __dirname;

//multer upload storage
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, __basedir + '/usersPhotoStorage/')
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
}}).array('photos',4);



module.exports.userRegister = (req,res)=>{
    uploadStorage(req, res, (err) => {
        if(err){
           // console.log(err)
            if(err.code === "LIMIT_UNEXPECTED_FILE"){
                return res.send("Too many image to upload.");
            }
        } 
        else {
           var validEmail = validator.isEmail(req.body.email);
           if(validEmail){
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
                else if (req.files.length < 4) {
                    return res.send("Must upload 4 photos");
                
                }else {

                function unlinkImage(n){
                    for(let i=0;i<n;i++){ 
                        var filepath= path.resolve(__basedir ,'./usersPhotoStorage/' + req.files[i].filename);
                        console.log(filepath)
                        fs.unlink(filepath,function(err,result){
                            console.log(err);

                        });
                    }
                        
                } 
                var newImg1 = fs.readFileSync(req.files[0].path);
                var encImg1 = newImg1.toString('base64');
                var newImg2 = fs.readFileSync(req.files[1].path);
                var encImg2 = newImg2.toString('base64');
                var newImg3 = fs.readFileSync(req.files[2].path);
                var encImg3 = newImg3.toString('base64');
                var newImg4 = fs.readFileSync(req.files[3].path);
                var encImg4 = newImg4.toString('base64');
                    
                var user = new User();
                user.firstName = req.body.firstName;
                user.lastName = req.body.lastName;
                user.email = req.body.email;
                user.mobile = formatedphone;
                user.category = req.body.category;
                user.video = req.body.video;
                user.gender = req.body.gender;
                user.photo1.data = Buffer.from(encImg1, 'base64');
                user.photo1.contentType='image/png';
                user.photo2.data = Buffer.from(encImg2, 'base64');
                user.photo2.contentType='image/png';
                user.photo3.data = Buffer.from(encImg3, 'base64');
                user.photo3.contentType='image/png';
                user.photo4.data = Buffer.from(encImg4, 'base64');
                user.photo4.contentType='image/png';

                
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
            }else{
                return res.send("Enter valid Email");
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
                              .populate('category')
                              .skip(offset) 
                              .limit(limit); 
          
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

module.exports.updateUserProfile =(req,res)=>{
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
        var validEmail = validator.isEmail(req.body.email);
        if(validEmail){   
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
            return res.send("Enter valid Email...");
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
   User.findById(req.params.id,function(err,user){
    if(err){
        return res.status(404).send({
            message: "User not found"
        });
    }else{
        user.remove();
        res.send({message: "User deleted successfully!"});
    }
})

 //   fs.unlinkSync(filepath);

}

module.exports.updateLike =(req,res)=>{
   User.findOne({_id:req.params.id},(err,user)=>{
       if(err){
           res.send({error:err})
       }else{
           if(user.disLike.indexOf(req.body.like !== -1)){
                User.findByIdAndUpdate(req.params.id,{
                    $pull:{
                        disLike:req.body.like
                    },
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
            else if(user.like.indexOf(req.body.like) !== -1){
                console.log('exist')
                User.findByIdAndUpdate(req.params.id,{
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
                User.findByIdAndUpdate(req.params.id,{
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

module.exports.updateDisLike =(req,res)=>{
    User.findOne({_id:req.params.id},(err,user)=>{
        if(err){
            res.send({error:err})
        }else{
            if(user.like.indexOf(req.body.disLike !== -1)){
                User.findByIdAndUpdate(req.params.id,{
                    $pull:{
                        like:req.body.disLike
                    },
                    $push:{
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
               
           }
            else if(user.disLike.indexOf(req.body.disLike) !== -1){
                 console.log('exist')
                 User.findByIdAndUpdate(req.params.id,{
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
                 User.findByIdAndUpdate(req.params.id,{
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
                             .populate('category')
                             .skip(offset) 
                             .limit(limit); 
         
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

module.exports.fetchImage =(req,res)=>{

    User.findById(req.params.id)
    .then(user => {
        res.setHeader('content-type',user.photo4.contentType);
        res.send(user.photo4.data);
    }).catch(err => {
        if(err.kind === 'ObjectId' || err.name === 'NotFound') {
            return res.status(404).send({
                message: "User found with id " + req.params.id
            });                
        }
        return res.status(500).send({
            message: "Could not delete User with id " + req.params.id
        });
    });

}





