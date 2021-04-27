const mongoose = require('mongoose');
const Admin = require('../models/admin.models');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const passport = require('passport');
const Request = require('../models/request.models');


module.exports.adminRegister = (req,res,next)=>{
    var admin = new Admin({
        userName:req.body.userName,
        email:req.body.email,
        password:req.body.password,
        role:"Admin"

    });
    
    admin.save((err,doc)=>{
        if(!err)
            res.status(201).send(doc);
        else{
            if(err)
                res.status(422).send(err.errors.email.message);
            else
                return next(err);    
        }
            
    });
}

module.exports.normalUserRegister = (req,res,next)=>{
     var admin = new Admin({
         userName:req.body.userName,
         email:req.body.email,
         password:req.body.password,
         role:"NormalUser"
         });
     
     admin.save((err,doc)=>{
         if(!err)
             res.status(201).send(doc);
         else{
             if(err)
                 res.status(422).send(err.errors.email.message);
             else
                 return next(err);    
         }
             
     });
 }

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
        let isMatch = await bcrypt.compare(password, admin.password);
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
    var request = new Request({
        description:req.body.description,
        applyer:req.body.applyer,
        requestedUser:req.body.requestedUser
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

//show requests
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
module.exports.acceptRequests = async(req,res)=>{
    await Request.findByIdAndUpdate(req.params.id,{
      $set:{
       isApprove:req.body.isApprove
      }  
    }, {new: true})
    .then(requ => {
        if(!requ) {
            return res.status(404).send({
                message: "Request not found with this " + req.params.id
            });
        }
        res.send({
               message:"Request Approve Successfully Come to office and talk to us!!"
        });
    }).catch(err => {
        if(err.kind === 'ObjectId') {
            return res.status(404).send({
                message: "Request not found with this " + req.params.id
            });                
        }
        return res.status(500).send({
            message: "Error updating Request with id " + req.params.id
        });
  });

}

