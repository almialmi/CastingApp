const mongoose = require('mongoose');
const Reset = require('../models/reset.models');
const Admin = require('../models/admin.models');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const passport = require('passport');
const Request = require('../models/request.models');
const nodemailer = require("nodemailer");
const crypto = require('crypto');
const { roles } = require('./role');
const moment = require('moment-timezone');
const validator =require('validator');
const cookieParser = require('cookie-parser');
const multer = require('multer');
const fs = require('fs');
const path = require('path');
const phoneToken = require('generate-sms-verification-code');
const emailValidator = require('deep-email-validator');
const { passwordStrength } = require('check-password-strength')


const user = process.env.ADMIN_EMAIL;
const pass = process.env.ADMIN_PASSWORD;


async function isEmailValid(email) {
    return emailValidator.validate(email)
}

const transport = nodemailer.createTransport({
    host: "smtp.gmail.com",
    service: "Gmail",
    port: 465,
    secure:true,
    auth: {
      user: user,
      pass: pass,
    },
  });

const sendConfirmationEmail = (name, email, confirmationCode) => {
    console.log("Check");
    transport.sendMail({
      from:{
          name:"ZeArada Film Production",
          address:user
        },
      to: email,
      subject: "Please confirm your account",
      html: `<h1>Email Confirmation</h1>
          <h2>Hello ${name}</h2>
          <p>Thank you for Joining us. Please confirm your email by copy the following code and past </p>
          <p> ${confirmationCode}  </p>
          </div>`,
    }).catch(err => console.log(err));
  };

global.__basedir = __dirname;

  //multer upload storage
const storage = multer.diskStorage({
      destination: (req, file, cb) => {
          cb(null,'./adminProfilePicStorage/')
      },
      filename: (req, file, cb) => {
          cb(null, file.fieldname + "-" + Date.now() + "-" + file.originalname)
      }
  
  });
  
const uploadStorage = multer({storage:storage,
       limits:{
            fileSize:1024 * 1024 * 5
       },
      fileFilter : function(req, file, callback) { //file filter
      if (['png','jpg','gif','jepg'].indexOf(file.originalname.split('.')[file.originalname.split('.').length-1]) === -1) {
          return callback(new Error('Wrong extension type'));
      }
      callback(null, true);
}}).single('photo');

module.exports.adminRegister = async(req,res,next)=>{
    const {valid, reason, validators} = await isEmailValid(req.body.email);
   // if (valid) return res.send({message: "OK"});
    //var validEmail = validator.isEmail(req.body.email);
     passwordStrengthCheck = passwordStrength(req.body.password).value

    if(valid){ 
        if(passwordStrengthCheck == "Medium" || passwordStrengthCheck == "Strong"){
            const token = phoneNumberToken(6, {type: 'number'})
            var admin = new Admin({
                userName:req.body.userName,
                email:req.body.email,
                password:req.body.password,
                role:"Admin",
                confirmationCode: token
            });
            
            admin.save((err)=>{
                if(!err){
                    sendConfirmationEmail(
                        admin.userName,
                        admin.email,
                        admin.confirmationCode
                    );
                    res.send({
                        message:"Admin is registered successfully! Please check your email"
                    });

                }
                else{
                    if(err)
                        res.status(422).send(err.message);
                    else
                        return next(err);    
                }
                    
            });
        }else{
            res.send("please enter strong by the combination of capital letter,special character and small letter!!")
        }
    }else{
        return res.status(400).send({
            message: "Please provide a valid email address.",
            reason: validators[reason].reason
        })

    }
    
}

module.exports.normalUserRegister = async(req,res,next)=>{
    const {valid, reason, validators} = await isEmailValid(req.body.email);
    passwordStrengthCheck = passwordStrength(req.body.password).value
    //var validEmail = validator.isEmail(req.body.email);
    if(valid){
        if(passwordStrengthCheck == "Medium" || passwordStrengthCheck == "Strong"){
            const token = phoneNumberToken(6, {type: 'number'})
            var admin = new Admin({
                userName:req.body.userName,
                email:req.body.email,
                password:req.body.password,
                confirmationCode: token
                });
            
            admin.save((err)=>{
                if(!err){
                    res.send({
                        message:
                        "User is registered successfully! Please check your email",
                    });
                    sendConfirmationEmail(
                        admin.userName,
                        admin.email,
                        admin.confirmationCode
                    );
                }
                else{
                    if(err)
                        res.status(422).send(err.message);
                    else
                        return next(err);    
                }
                    
            });
    }else{
        res.send("please enter strong by the combination of capital letter,special character and small letter!!")
    }
    }else{
        return res.status(400).send({
            message: "Please provide a valid email address.",
            reason: validators[reason].reason
        })
    }
    
 }

//verfiy the email
module.exports.verifyUser = (req, res) => {
    Admin.findOne({
      confirmationCode: req.params.confirmationCode,
    }).then((admin) => {
        if (!admin) {
          return res.status(404).send({ message: "User Not found." });
        }
        id = admin.id
        Admin.findByIdAndUpdate(id,{
            $set:{
                status : "Active"
            }
        }, {new: true})
        .then(admin => {
            if(!admin) {
                return res.status(404).send({
                    message: "Admin or NormalUser not found with this " + id
                });
            }
            res.send({
                   message:"User Account activate"
            });
        }).catch(err => {
            if(err.kind === 'ObjectId') {
                return res.status(404).send({
                    message: "Admin or NormalUser not found with this " + id
                });                
            }
            return res.status(500).send({
                message: "Error updating Admin or NormalUser profile with id " + id
            });
      });
      })
      .catch((e) => console.log("error", e));
  };




module.exports.updateAdminAndNormalUserProfile = async(req,res)=>{
    var id;
    var token= req.body.token || req.query.token || req.cookies['token'] || req.headers['token'];
        //console.log(token);
    jwt.verify(token , process.env.JWT_SECRET , (err , decoded) => {
        id = decoded.admin_id;
    });

    if(!req.body.email && !req.body.password){
        Admin.findByIdAndUpdate(id,{
            $set:{
                userName:req.body.userName
            }
        }, {new: true})
        .then(admin => {
            if(!admin) {
                return res.status(404).send({
                    message: "Admin or NormalUser not found with this " + id
                });
            }
            res.send({
                   message:"UserName Update Successfully !!"
            });
        }).catch(err => {
            if(err.kind === 'ObjectId') {
                return res.status(404).send({
                    message: "Admin or NormalUser not found with this " + id
                });                
            }
            return res.status(500).send({
                message: "Error updating Admin or NormalUser profile with id " + id
            });
      });
    }
    else if(!req.body.email && !req.body.userName){
        passwordStrengthCheck = passwordStrength(req.body.password).value
        if(passwordStrengthCheck == "Medium" || passwordStrengthCheck == "Strong"){
            const salt = await bcrypt.genSaltSync(10);
            const password = await req.body.password;
            Admin.findByIdAndUpdate(id,{
                $set:{
                    password:bcrypt.hashSync(password, salt)
                }
            }, {new: true})
            .then(admin => {
                if(!admin) {
                    return res.status(404).send({
                        message: "Admin or NormalUser not found with this " + id
                    });
                }
                res.send({
                    message:"Password Update Successfully !!"
                });
            }).catch(err => {
                if(err.kind === 'ObjectId') {
                    return res.status(404).send({
                        message: "Admin or NormalUser not found with this " + id
                    });                
                }
                return res.status(500).send({
                    message: "Error updating Admin or NormalUser profile with id " + id
                });
        });

        }else{
            res.send("please enter strong by the combination of capital letter,special character and small letter!!")
        }        
    }
    else if(!req.body.password && !req.body.userName){
        const {valid, reason, validators} = await isEmailValid(req.body.email);
       // var validEmail = validator.isEmail(req.body.email);
        if(valid){   
            Admin.findByIdAndUpdate(id,{
                $set:{
                    email:req.body.email
                }
            }, {new: true})
            .then(admin => {
                if(!admin) {
                    return res.status(404).send({
                        message: "Admin or NormalUser not found with this " + id
                    });
                }
                res.send({
                       message:"Email Update Successfully !!"
                });
            }).catch(err => {
                if(err.kind === 'ObjectId') {
                    return res.status(404).send({
                        message: "Admin or NormalUser not found with this " + id
                    });                
                }
                return res.status(500).send({
                    message: "Error updating Admin or NormalUser profile with id " + id
                });
          });
    
        }else{
            return res.status(400).send({
                message: "Please provide a valid email address.",
                reason: validators[reason].reason
            })
        }
    }else{
        return res.send("Choose what you want to update...");   
    } 
}

module.exports.adminAndNormalUserLogin = async(req , res , next) => {
    try {
        const { email,password } = req.body;
        const admin = await Admin.findOne({ email });
        if (!admin) {
            return res.status(404).json({
                message:'Email is not found',
                success:false
            })
        }
        if(admin.status === "Pending"){
            return res.status(403).json({
                message:'Your Account is deactivated',
                success:false
            })

        }
        if (admin.isLocked) {
            return admin.incrementLoginAttempts(function(err) {
                if (err) {
                    return send({
                        message:err
                    });
                }
                return res.status(403).send({ 
                    message: 'You have exceeded the maximum number of login attempts.Your account is locked until ' + moment(admin.lockUntil).tz("East Africa Time ").format('LT z') + '.  You may attempt to log in again after that time.' });
            });
        }

       let isMatch = await bcrypt.compare(password,admin.password);
       // console.log(isMatch)
        if (isMatch) {
            var updates = {
                $set: { loginAttempts: 0 },
                $unset: { lockUntil: 1 }
            }
            admin.updateOne(updates, function(err) {
                if (err) console.log(err);
            });
            let token = jwt.sign({
                admin_id:admin._id,
                role:admin.role,
                email:admin.email
            },
            process.env.JWT_SECRET,
          { expiresIn :process.env.JWT_EXP });
          
          let result ={
              token: `${token}`
             }
      
        res.cookie('token', token, {
            expires: new Date(Date.now() + 300000000000000),
            secure: false, 
            httpOnly: true,
        });
        return res.status(200).json({ message: "Login Successfully!!"});
        
         /*return res.status(200).send({
              ...result,
              message:'Login successfully !!',
              success:true
        }) */
        }else{
            admin.incrementLoginAttempts(function(err) {
                if (err) {
                    return res.status(403).send(err);
                }
                return res.status(403).json({
                    message:'Incorrect password',
                    success:false
                });
            });

        }
       } catch (error) {
        next(error);
       } 
}

module.exports.fetchNormalUserForAdmin = async(req,res)=>{
   try {
        let page = parseInt(req.query.page);
        let limit = parseInt(req.query.size);
       
        const offset = page ? page * limit : 0;
    
        console.log("offset = " + offset);    
    
        let result = {};
        let numOfStaffs;
	    let role = 'NormalUser'

        
        numOfStaffs = await Admin.countDocuments({});
        result = await Admin.find({role:role},{password: 0,salSecrete:0,__v:0}) 
                              .skip(offset) 
                              .limit(limit)
                              .sort({$natural:-1}); 
          
        const response = {
          "totalItems": numOfStaffs,
          "totalPages": Math.ceil(result.length / limit),
          "pageNumber": page,
          "pageSize": result.length,
          "NormalUsers": result
        };
    
        res.status(200).json(response);
      } catch (error) {
        res.status(500).send({
          message: "Error -> Can NOT complete a paging request!",
          error: error.message,
        });
      }
 


}

module.exports.fetchOwnProfile = async(req,res)=>{
    try {
        var id;
        var token= req.body.token || req.query.token || req.cookies['token'] || req.headers['token'];
        //console.log(token);
        jwt.verify(token , process.env.JWT_SECRET , (err , decoded) => {
            id = decoded.admin_id;
        });
        Admin.findById(id, function (err, admin) {
            if (err){
                res.status(401).send(err)
            }
            else{
                res.status(200).send({
                        "_id":admin._id,
                        "userName":admin.userName,
                        "email":admin.email,
                        "profilePic":admin.profilePic
                })
            }
        })
       } catch (error) {
        next(error)
    }

}



module.exports.Authenticate = passport.authenticate('cookie',{session:false});

//request related staff

// create request a user for work
module.exports.createRequest=(req,res,next)=>{
    var id;
    var token= req.body.token || req.query.token || req.cookies['token'] || req.headers['token'];
        //console.log(token);
        jwt.verify(token , process.env.JWT_SECRET , (err , decoded) => {
            id = decoded.admin_id;
    });
    var dateForWork = new Date(req.body.dateForWork);
    var request = new Request({
        description:req.body.description,
        applyer:id,
        requestedUser:req.body.requestedUser,
        duration:req.body.duration,
        dateForWork:dateForWork
    });
    request.save((err,cat)=>{
        if(!err)
            res.status(201).send({
                message:"Request send successfully!!"
            });
        else{
            if(err)
                res.status(422).send(err);
            else
                return next(err);    
        }
            
    });
     
}

// show there own created request for normal user
module.exports.showOwnRequests= async(req,res)=>{

    try {
        let page = parseInt(req.query.page);
        let limit = parseInt(req.query.size);
       
        const offset = page ? page * limit : 0;
    
        console.log("offset = " + offset);    
    
        let result = {};
        let numOfStaffs;
        let applyer;
        var token= req.body.token || req.query.token || req.cookies['token'] || req.headers['token'];
        //console.log(token);
        jwt.verify(token , process.env.JWT_SECRET , (err , decoded) => {
            applyer = decoded.admin_id;
        });
        numOfStaffs = await Request.countDocuments({});
        result = await Request.find({applyer:applyer},{__v:0}) 
                              .populate('applyer',{email:1,userName:1,profilePic:1})
                              .populate('requestedUser',{mobile:1,firstName:1,lastName:1,photo1:1})
                              .skip(offset) 
                              .limit(limit)
                              .sort({$natural:-1}); 
          
        const response = {
          "totalItems": numOfStaffs,
          "totalPages": Math.ceil(result.length / limit),
          "pageNumber": page,
          "pageSize": result.length,
          "Request": result
        };
    
        res.status(200).json(response);
      } catch (error) {
        res.status(500).send({
          message: "Error -> Can NOT complete a paging request!",
          error: error.message,
        });
      }
}


//show requests for admin
module.exports.showRequests= async(req,res)=>{

    try {
        let page = parseInt(req.query.page);
        let limit = parseInt(req.query.size);
       
        const offset = page ? page * limit : 0;
    
        console.log("offset = " + offset);    
    
        let result = {};
        let numOfStaffs;

        
        numOfStaffs = await Request.countDocuments({});
        result = await Request.find({},{__v:0}) 
                              .populate('applyer',{email:1,userName:1,profilePic:1})
                              .populate('requestedUser',{mobile:1,firstName:1,lastName:1,photo1:1})
                              .skip(offset) 
                              .limit(limit)
                              .sort({$natural:-1}); 
          
        const response = {
          "totalItems": numOfStaffs,
          "totalPages": Math.ceil(result.length / limit),
          "pageNumber": page,
          "pageSize": result.length,
          "Request": result
        };
    
        res.status(200).json(response);
      } catch (error) {
        res.status(500).send({
          message: "Error -> Can NOT complete a paging request!",
          error: error.message,
        });
      }
}

// approve for request need notification...

module.exports.acceptOrRejectRequests = async(req,res)=>{

    if(req.body.approve == null) {
        return res.status(400).send({
            message: "You should choose!!!"
        });
    }
    await Request.findByIdAndUpdate(req.params.id, {
        $set:{
            approve:req.body.approve
        }
        
    }, {new: true})
    .then(reque => {
        if(!reque) {
            return res.status(404).send({
                message: "Request not found with id " + req.params.id
            });
        }
        res.status(200).send({
            message:"Request Approve/reject successfully",
            success:true
        });
    }).catch(err => {
        if(err.kind === 'ObjectId') {
            return res.status(404).send({
                message: "Request not found with id " + req.params.id
            });                
        }
        return res.status(500).send({
            message: "Error updating Request with id " + req.params.id
        });
    });

}


module.exports.deleteRequests =(req,res)=>{
    Request.findByIdAndRemove(req.params.id)
    .then(reqs => {
        if(!reqs) {
            return res.status(404).send({
                message: "Request not found with id " + req.params.id
            });
        }
        res.send({message: "Request deleted successfully!"});
    }).catch(err => {
        if(err.kind === 'ObjectId' || err.name === 'NotFound') {
            return res.status(404).send({
                message: "Request found with id " + req.params.id
            });                
        }
        return res.status(500).send({
            message: "Could not delete Request with id " + req.params.id
        });
    });
}

// forgot password 
module.exports.forgotPassword = async(req,res)=>{
        if (!req.body.email) {
            return res.status(500).send({ message: 'Email is required' });
        }
        const admin = await Admin.findOne({
            email:req.body.email
        });
        if (!admin) {
        return res.status(404).send({ message: 'Email does not exist' });
        }
        var resettoken = new Reset({ _userId: admin._id, resettoken: phoneToken(6,{type:'number'})});

        await resettoken.save(function (err) {
            if (err) { return res.status(500).send({ msg: err.message }); }
             
         });
        await Reset.findOne({ _userId: admin._id,resettoken: { $ne: resettoken.resettoken }}).deleteOne().catch();
      
        transport.sendMail({
            to: admin.email,
            from:{
                name:"ZeArada Film Production",
                address:user
            },
            subject: 'ZeArada Film Production App RestPassword',
            text: 'You are receiving this because you (or someone else) have requested the reset of the password for your account.\n\n' +
            'Please enter the following code to the appication.\n\n' + 
            resettoken.resettoken + '\n\n' +
            'If you did not request this, please ignore this email and your password will remain unchanged.\n'

        }).then((result) =>{
            res.status(200).send({
                message: 'Reset password code send.Check your email.' 
            });
            
        }).catch((err)=>{
            res.status(400).send({
                message: 'connection time out' 
            })
        });
              
}

// validate the token
module.exports.validateToken = async(req,res)=>{
        if (!req.body.resettoken) {
             return res.status(500).json({ message: 'Token is required' });
        }
        const admin = await Reset.findOne({
            resettoken: req.body.resettoken
        });
        if (!admin) {
        return res.status(409) .send({ 
            message: 'Invalid code' 
        });
        }
        Admin.findOneAndUpdate({id: admin._userId }).then(() => {
            res.status(200).send({ message: 'Token verified successfully.' });
        }).catch((err) => {
             return res.status(500).send({ msg: err.message });
        });

}

// new password
module.exports.newPassword= async(req,res)=>{
    Reset.findOne({ resettoken: req.body.resettoken }, function (err, userToken, next) {
        if (!userToken) {
          return res .status(409) .json({ 
              message: 'Token has expired or not found' 
            });
        }
  
        Admin.findOne({ _id: userToken._userId}, function (err, userEmail, next) {
          if (!userEmail) {
            return res .status(409) .json({ 
                message: 'User does not exist'
             });
          }
          passwordStrengthCheck = passwordStrength(req.body.newPassword).value
          if(passwordStrengthCheck == "Medium" || passwordStrengthCheck == "Strong"){
            userEmail.password = req.body.newPassword;
            userEmail.save(function (err) {
                if (err) {
                  return res.status(400) .send({ 
                      message: 'Password can not reset.' 
                  });
                } else {
                  userToken.remove();
                  return res.status(201).send({ 
                      message: 'Password reset successfully' 
                  });
                }
    
              });

          }else{
            res.send("please enter strong by the combination of capital letter,special character and small letter!!")
          }
       
        });
  
      })
   
}


module.exports.grantAccess = function(action, resource) {
 return async (req, res, next) => {
    var role;
    var token= req.body.token || req.query.token || req.cookies['token'] || req.headers['token'];
    jwt.verify(token , process.env.JWT_SECRET , (err , decoded) => {
        role = decoded.role;
    });
    try {
        const permission = roles.can(role)[action](resource);
        if (!permission.granted) {
            return res.status(401).json({
            error: "You don't have enough permission to perform this action"
            });
        }
        next()
    } catch (error) {
        next(error)
    }
 }
}




module.exports.updateProfilePic = (req,res)=>{
    var id;
    var token= req.body.token || req.query.token || req.cookies['token'] || req.headers['token'];
        //console.log(token);
    jwt.verify(token , process.env.JWT_SECRET , (err , decoded) => {
        id = decoded.admin_id;
    });
    
    uploadStorage(req, res, (err) => {
        if(err){
            //console.log(err)
            if(err.code === "LIMIT_UNEXPECTED_FILE"){
                return res.send("Too many image to upload.");
            }
        } else {
            if(req.file == undefined){

                res.status(404).json({ success: false, msg: 'File is undefined!',file: `adminProfilePicStorage/${req.file}`});

            }    
            else {
                var filepath= path.resolve('./adminProfilePicStorage/' + req.file.filename);
               
                Admin.findByIdAndUpdate(id,{
                    $set:{
                        profilePic:req.file.path
                    }
                }, {new: true})
                .then(admin => {
                    if(!admin) {
                        fs.unlink(filepath)
                        return res.status(404).send({
                            message: " User not found with this " + id
                        });
                    }
                    res.send({
                           message:"Profile Pic Update Successfully !!"
                    });
                }).catch(err => {
                    fs.unlink(filepath)
                    if(err.kind === 'ObjectId') {
                        return res.status(404).send({
                            message: "User not found with this " + id
                        });                
                    }
                    return res.status(500).send({
                        message: "Error updating User with id " + id
                    });
              });

 }}});

}

module.exports.logout =(req,res,next)=>{
    res.cookie('token','none',{
        httpOnly: true,
    });

    res.status(200).send({
        success:true,
        data:{}
    });

}






