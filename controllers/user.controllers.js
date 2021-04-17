const User = require('../models/user.models');
const Admin = require('../models/admin.models');
const multer = require('multer');

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
    if (['png'].indexOf(file.originalname.split('.')[file.originalname.split('.').length-1]) === -1) {
        return callback(new Error('Wrong extension type'));
    }
    callback(null, true);
}}).array('photos',4);



module.exports.userRegister = (req,res)=>{
    uploadStorage(req, res, (err) => {
        if(err){
            console.log(err)
        } else {
            let formatedphone = 0;
            let phone = req.body.mobile;
            if (phone.charAt(0) == '0') {
                formatedphone = '+251' + phone.substring(1);
            } else if ((phone.charAt(0) == '+') && (phone.length > 12 || phone.length <= 13)) {
                formatedphone = phone
            }

            console.log(req.files[0].filename)
            //console.log(req.file)

            if(req.files == undefined){

                res.status(404).json({ success: false, msg: 'File is undefined!',file: `usersPhotoStorage/${req.files}`})

            } else {
               var user = new User();
                user.firstName = req.body.firstName;
                user.lastName = req.body.lastName;
                user.email = req.body.email;
                user.mobile = formatedphone;
                user.category = req.body.category;
                user.video = req.body.video;
                user.gender = req.body.gender;
                user.photos.data = req.files;
                user.photos.contentType='image/png';

                user.save((err,doc)=>{
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

module.exports.fetchUser = async(req,res)=>{
  /*  User.find({__v:0}).populate('category')
                      .exec((err,result)=>{
                       if(err){
                          res.send(err)
                       }else{
                         res.send(result)
                     }
                });*/

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
          "Users": result
        };
    
        res.status(200).json(response);
      } catch (error) {
        res.status(500).send({
          message: "Error -> Can NOT complete a paging request!",
          error: error.message,
        });
      }
     

}

module.exports.updateUser =(req,res)=>{
  
    uploadStorage(req, res, (err) => {
        if(err){
            console.log(err)
        } else {
            //console.log(req.files[0].filename)
            //console.log(req.file)

            if(req.files == undefined){

                res.status(404).json({ success: false, msg: 'File is undefined!',file: `usersPhotoStorage/${req.files}`})

            }
            else if (!req.body.firstName && !req.body.lastName && !req.body.email && !req.body.mobile && !req.body.video && !req.body.category && !req.body.gender){
                    return res.status(400).send({
                             message:"this content cann't be empty"
                    });
            }
            
            else {
                let formatedphone = '';
                let phone = req.body.mobile;
                if (phone.charAt(0) == '0') {
                    formatedphone = '+251' + phone.substring(1);
                } else if ((phone.charAt(0) == '+') && (phone.length > 12 || phone.length <= 13)) {
                    formatedphone = phone
                }

                User.findByIdAndUpdate(req.params.id,{
                    $set:{
                        firstName:req.body.firstName,
                        lastName:req.body.lastName,
                        email:req.body.email,
                        mobile:formatedphone,
                        category:req.body.category,
                        video:req.body.video,
                        gender:req.body.gender,
                        photos:req.files
   
                    }
                }, {new: true})
                .then(user => {
                    if(!user) {
                        return res.status(404).send({
                            message: " User not found with this " + req.params.id
                        });
                    }
                    res.send({
                           message:"Profile Update Successfully !!"
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

 }}});

}

module.exports.deleteUser= (req,res)=>{
    User.findByIdAndRemove(req.params.id)
    .then(user => {
        if(!user) {
            return res.status(404).send({
                message: "User not found with id " + req.params.id
            });
        }
        res.send({message: "User deleted successfully!"});
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

module.exports.updateLike =(req,res)=>{
  User.findById(req.params.id, function (err, user) {
    if (err) {
        console.log(err);
    } else {
        user.like += 1;
        user.save();
        console.log(user.like);
        res.send({
            likeCount: user.like,
            message:"Like Update Successfully !!"
        }); 
    }
});

User.findByIdAndUpdate(req.params.id,{
    $push:{like:req.body.like}
})

}

module.exports.updateDisLike =(req,res)=>{
    User.findById(req.params.id, function (err, user) {
        if (err) {
            console.log(err);
        } else {
            user.disLike += 1;
            user.save();
            console.log(user.disLike);
            res.send({
                likeCount: user.disLike,
                message:"DisLike Update Successfully !!"
            }); 
        }
    });

}