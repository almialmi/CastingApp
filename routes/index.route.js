const express = require('express');
const router = express.Router();

const ctrlUser = require('../controllers/user.controllers');
const ctrlEvent = require('../controllers/event.controllers');
const ctrlCategory = require('../controllers/category.controllers');
const ctrlAdmin = require('../controllers/admin.controllers');
const ctrlComputPost = require('../controllers/computationPost.controllers');
const jwtHelper = require('../config/jwtHelper');


//category section

//create category
router.post('/createCategory',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlCategory.registerCategory);

//show category
router.get('/showCategory',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlCategory.showCategory);

//update category
router.put('/updateCategory/:id',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlCategory.upadteCategoty);

//delete category 
router.delete('/deleteCategory/:id/:filename',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlCategory.deleteCategory);


//admin section
//admin register
router.post('/registerAdmin',ctrlAdmin.adminRegister);

// normal user register
router.post('/registerNormalUser',ctrlAdmin.normalUserRegister);

// verfiy the email
router.get("/verfiyEmail/:confirmationCode",ctrlAdmin.verifyUser);

//update profile 
router.put('/updateAdminAndNormalUserProfile/:id',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlAdmin.updateAdminAndNormalUserProfile);

//Admin and normal user login
router.post('/adminAndNormalUserLogin',ctrlAdmin.adminAndNormalUserLogin);

// fetch NormalUser for Admin
router.get('/fetchNormalUserForAdmin',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlAdmin.fetchNormalUserForAdmin);

//fetch Admin

router.get('/fetchAdmin',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlAdmin.fetchAdmin);

//user section
//register user 
router.post('/registerUser',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlUser.userRegister);

//fetch user 
router.get('/fetchAllUser',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlUser.fetchAllUser);

//fetch based on category and gender

// male
router.get('/fetchMaleAndFemaleUser/:category/:gender',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlUser.fetchUserMaleAndFemale);


//update user
router.put('/updateUser/:id',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlUser.updateUser);

//delete user 
router.delete('/deleteUser/:id/:files',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlUser.deleteUser);

//update like
router.put('/updateLike/:id',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlUser.updateLike);

//update Dislike
router.put('/updateDisLike/:id',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlUser.updateDisLike);

//Request section 
//create requests
router.post('/createRequest',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlAdmin.createRequest);

// show own request
router.get('/fetchOwnRequest/:applyer',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlAdmin.showOwnRequests);

//show requests
router.get('/showRequests',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlAdmin.showRequests);

// delete created request 

router.delete('/deleteRequest/:id',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlAdmin.deleteRequests);

//approve
router.put('/approveOrRejectRequest/:id',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlAdmin.acceptOrRejectRequests);

//reject
//router.put('/rejectRequest/:id',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlAdmin.rejectRequests);




//event section
//register event
router.post('/registerEvent',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlEvent.registerEvent);

//show events
router.get('/showEvents/:closed',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlEvent.showEvents);

//update events
router.put('/updateEvent/:id',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlEvent.updateEvent);

//delete events
router.delete('/deleteEvent/:id/:filename',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlEvent.deleteEvent);

//show remainig time and tell closed or expired date
router.get('/showRemaingTimeAndExpiredDate/:id',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlEvent.showRemainingTimeAndExpried);


//computation post section
//register comput posts
router.post('/registerComputationPost',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlComputPost.addComputationPost);

//show posts
router.get('/showComputationPosts',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlComputPost.showComputationPosts);

//update like when it clicks
router.put('/updateNumberOfLikes/:id',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlComputPost.updateNumberOfLikes);

//update number of dis like
router.put('/updateNumberOfDisLikes/:id',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlComputPost.updateNumberOfDisLikes);

//to delete posts
router.delete('/deleteComputationPost/:id',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlComputPost.deletePost);

//fill juge points
router.put('/fillJugePoints/:id',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlComputPost.fillJugePoints);

//to show posts based on number of likes and juge points
router.get('/higherToLowerLikes',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlComputPost.orderByHighestLikeToTheEvent);

//show best 3 winners
router.get('/showBestThreeWinners',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlComputPost.notifyBestThreeWinners);

//forgot password
router.post('/resetPassword',ctrlAdmin.forgotPassword);

//validate token
router.post('/validateToken',ctrlAdmin.validateToken);

// new password
router.post('/newPassword',ctrlAdmin.newPassword);

module.exports = router;
