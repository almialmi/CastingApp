const User = require('../models/user.models');
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
            console.log(req.files[0].filename)
            //console.log(req.file)

            if(req.files == undefined){

                res.status(404).json({ success: false, msg: 'File is undefined!',file: `usersPhotoStorage/${req.files}`})

            } else {
               var user = new User();
                user.firstName = req.body.firstName;
                user.lastName = req.body.lastName;
                user.email = req.body.email;
                user.mobile = req.body.mobile;
                user.category = req.body.category;
                user.video = req.body.video;
                user.gender = req.body.gender;
                user.photos.data = req.files;
                user.photos.contentType='image/png';

                user.save({ $inc:{ orderNumber : 1 } },(err,doc)=>{
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