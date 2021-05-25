const mongoose = require('mongoose');
const Reset = require('../models/reset.models');
const Admin = require('../models/admin.models');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const passport = require('passport');
const Request = require('../models/request.models');
const nodemailer = require("nodemailer");
const crypto = require('crypto');

const user = "almialmi61621@gmail.com";
const pass = "Cybma12345";

const transport = nodemailer.createTransport({
    host: "smtp.gmail.com",
    service: "Gmail",
    port: 465,
    secure:false,
    auth: {
      user: user,
      pass: pass,
    },
  });

const sendConfirmationEmail = (name, email, confirmationCode) => {
    console.log("Check");
    transport.sendMail({
      from: user,
      to: email,
      subject: "Please confirm your account",
      html: `<h1>Email Confirmation</h1>
          <h2>Hello ${name}</h2>
          <p>Thank you for Joining us. Please confirm your email by clicking on the following link</p>
          <a href=http://localhost:4200/verfiyEmail/${confirmationCode}> Click here</a>
          </div>`,
    }).catch(err => console.log(err));
  };

module.exports.adminRegister = (req,res,next)=>{
    const token = jwt.sign({email: req.body.email}, process.env.JWT_SECRET)
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
                message:"User was registered successfully! Please check your email"
            });

        }
        else{
            if(err)
                res.status(422).send(err.message);
            else
                return next(err);    
        }
            
    });
}

module.exports.normalUserRegister = (req,res,next)=>{
    const token = jwt.sign({email: req.body.email}, process.env.JWT_SECRET)
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
                   "User was registered successfully! Please check your email",
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
 }

//verfiy the email
exports.verifyUser = (req, res, next) => {
   Admin.findOne({
      confirmationCode: req.params.confirmationCode,
    }).then((admin) => {
        if (!admin) {
          return res.status(404).send({ message: "User Not found." });
        }
        admin.status = "Active";
        admin.save((err) => {
          if (err) {
            res.status(500).send({ message: err });
          }
          else{
            res.status(200).send({ message: "User Account activate"});

          }
        });
      })
      .catch((e) => console.log("error", e));
  };


module.exports.updateAdminAndNormalUserProfile = async(req,res)=>{
    console.log("request sent");
    if(!req.body.email && !req.body.password){
        return res.status(400).send({
                 message:"this content cann't be empty"
        });
    }
    
    const salt = await bcrypt.genSaltSync(10);
    const password = await req.body.password;
    
    Admin.findByIdAndUpdate(req.params.id,{
        $set:{
            userName:req.body.userName,
            email:req.body.email,
            password:bcrypt.hashSync(password, salt)

        }
    }, {new: true})
    .then(admin => {
        if(!admin) {
            return res.status(404).send({
                message: "Admin or NormalUser not found with this " + req.params.id
            });
        }
        res.send({
               message:"Profile Update Successfully !!"
        });
    }).catch(err => {
        if(err.kind === 'ObjectId') {
            return res.status(404).send({
                message: "Admin or NormalUser not found with this " + req.params.id
            });                
        }
        return res.status(500).send({
            message: "Error updating Admin or NormalUser profile with id " + req.params.id
        });
  });
    
}

module.exports.adminAndNormalUserLogin = async(req,res,next)=>{
    try {
        const { email, password } = req.body;
        const admin = await Admin.findOne({ email });
        if (!admin) {
            return res.status(404).json({
                message:'Email is not found',
                success:false
            })
        }
        if (admin.status != "Active") {
            return res.status(401).send({
              message: "Pending Account. Please Verify Your Email!",
            });
        }
        let isMatch = await bcrypt.compare(password,admin.password);
        if (isMatch) {
            let token = jwt.sign({
                admin_id:admin._id,
                email:admin.email,
                role:admin.role
                },
            process.env.JWT_SECRET,
          { expiresIn :process.env.JWT_EXP });
          let result ={
              token: `${token}`
             }
         return res.status(200).json({
              ...result,
              message:'Login successfully !!',
              success:true
        }) 


        }else{
            return res.status(403).json({
                message:'Incorrect password',
                success:false
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
                              .limit(limit); 
          
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

module.exports.fetchAdmin =(req,res)=>{
    let role = 'Admin'
    Admin.find({role:role},{salSecrete:0,__v:0},(err,result)=>{
        if(err){
            res.send(err)

        }else{
            res.send(result)
        }

    });

}



module.exports.Authenticate = passport.authenticate('jwt',{session:false});

//request related staff

// create request a user for work
module.exports.createRequest=(req,res,next)=>{
    var dateForWork = new Date(req.body.dateForWork);
    var request = new Request({
        description:req.body.description,
        applyer:req.body.applyer,
        requestedUser:req.body.requestedUser,
        duration:req.body.duration,
        dateForWork:dateForWork
    });
    request.save((err,cat)=>{
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

// show there own created request for normal user
module.exports.showOwnRequests= async(req,res)=>{

    try {
        let page = parseInt(req.query.page);
        let limit = parseInt(req.query.size);
       
        const offset = page ? page * limit : 0;
    
        console.log("offset = " + offset);    
    
        let result = {};
        let numOfStaffs;
        let applyer = req.params.applyer;
        console.log(applyer);
        
        numOfStaffs = await Request.countDocuments({});
        result = await Request.find({applyer:applyer},{__v:0}) 
                              .populate('applyer')
                              .populate('requestedUser')
                              .skip(offset) 
                              .limit(limit); 
          
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
        result = await Request.find({__v:0}) 
                              .populate('applyer')
                              .populate('requestedUser')
                              .skip(offset) 
                              .limit(limit); 
          
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

    if(!req.body.description && !req.body.applyer && !req.body.requestedUser) {
        return res.status(400).send({
            message: " All this contents cann't be empty"
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
        var resettoken = new Reset({ _userId: admin._id, resettoken: crypto.randomBytes(16).toString('hex') });

        await resettoken.save(function (err) {
            if (err) { return res.status(500).send({ msg: err.message }); }
             
         });
        await Reset.findOne({ _userId: admin._id,resettoken: { $ne: resettoken.resettoken }}).deleteOne().catch();
        res.status(200).send({
             message: 'Reset Password successfully.' 
        });

        var mailOptions = {
        to: admin.email,
        from: user,
        subject: 'Zerihun Casting Agent App RestPassword',
        text: 'You are receiving this because you (or someone else) have requested the reset of the password for your account.\n\n' +
        'Please click on the following link, or paste this into your browser to complete the process:\n\n' +
        'http://localhost:4200/response-reset-password/' + resettoken.resettoken + '\n\n' +
        'If you did not request this, please ignore this email and your password will remain unchanged.\n'
        }
       // console.log(resettoken.resettoken);
       // console.log(admin.email); 
        transport.sendMail(mailOptions, (err, response) => { 
            if(err){
                res.status(422).send({
                    message:err
                })
            }else{
                res.status(200).send({
                    message:"Message sent: " + response.msg
                })
            }
       })


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
            message: 'Invalid URL' 
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
              message: 'Token has expired' 
            });
        }
  
        Admin.findOne({ _id: userToken._userId}, function (err, userEmail, next) {
          if (!userEmail) {
            return res .status(409) .json({ 
                message: 'User does not exist'
             });
          }
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
       
        });
  
      })
   
}


