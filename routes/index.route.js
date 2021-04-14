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
router.delete('/deleteCategory/:id',jwtHelper.verifyJwtToken,ctrlAdmin.Authenticate,ctrlCategory.deleteCategory);


//admin section
//admin register
router.post('/registerAdmin',ctrlAdmin.adminRegister);

// normal user register
router.post('/registerNormalUser',ctrlAdmin.normalUserRegister);

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
router.post('/registerUser',ctrlUser.userRegister);

//event section
//register event
router.post('/registerEvent',ctrlAdmin.Authenticate,jwtHelper.verifyJwtToken,ctrlEvent.registerEvent);

//show events
router.get('/showEvents',ctrlEvent.showEvents);

//update events
router.put('/updateEvents/:id',ctrlAdmin.Authenticate,jwtHelper.verifyJwtToken,ctrlEvent.updateEvent);

//delete events
router.delete('/deleteEvents/:id',ctrlAdmin.Authenticate,jwtHelper.verifyJwtToken,ctrlEvent.deleteEvent);

//show remainig time and tell closed or expired date
router.get('/showRemaingTimeAndExpiredDate',ctrlEvent.showRemainingTimeAndExpried);


//computation post section
//register comput posts
router.post('/registerComputationPost',ctrlAdmin.Authenticate,jwtHelper.verifyJwtToken,ctrlComputPost.addPost);

//show posts
router.get('/showPosts',ctrlComputPost.showPosts);

//update like when it clicks
router.put('/updateLikes/:id',ctrlComputPost.updateLikes);

//to delete posts
router.delete('/deletePosts/:id',ctrlAdmin.Authenticate,jwtHelper.verifyJwtToken,ctrlComputPost.deletePost);

//fill juge points
router.put('/fillJugePoints/:id',ctrlAdmin.Authenticate,jwtHelper.verifyJwtToken,ctrlComputPost.fillJugePoints);

//to show posts based on number of likes and juge points
router.get('/higherToLowerLikes',ctrlComputPost.orderByHighestLikeToTheEvent);

//show best 3 winners
router.get('/showBestThreeWinners',ctrlComputPost.notifyBestThreeWinners);

//user section

module.exports = router;
