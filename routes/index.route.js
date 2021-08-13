const express = require('express');
const router = express.Router();

const ctrlUser = require('../controllers/user.controllers');
const ctrlEvent = require('../controllers/event.controllers');
const ctrlCategory = require('../controllers/category.controllers');
const ctrlAdmin = require('../controllers/admin.controllers');
const ctrlComputPost = require('../controllers/computationPost.controllers');
const jwtHelper = require('../config/jwtHelper');

//******************************* Category Section ********************************/

//create category
router.post('/createCategory',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('createAny','category'),ctrlCategory.registerCategory);

//show category
router.get('/showCategory',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('readAny','category'),ctrlCategory.showCategory);

//update category profile pic
router.put('/upadteCategotyProfilePic/:id',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('updateAny','category'),ctrlCategory.upadteCategotyProfilePicOrBoth);

// update category profile
router.put('/updateCatagoryProfile/:id',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('updateAny','category'),ctrlCategory.updateCatagoryProfile)


//delete category 
router.delete('/deleteCategory/:id',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('deleteAny','category'),ctrlCategory.deleteCategory);

//****************************** Admin Section ************************************/
//admin register
router.post('/registerAdmin',ctrlAdmin.adminRegister);

// normal user register
router.post('/registerNormalUser',ctrlAdmin.normalUserRegister);

// verfiy the email
router.get("/verfiyEmail/:confirmationCode",ctrlAdmin.verifyUser);

//update profile 
router.put('/updateAdminAndNormalUserProfile',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('updateOwn','profile'),ctrlAdmin.updateAdminAndNormalUserProfile);

//Admin and normal user login
router.post('/adminAndNormalUserLogin',ctrlAdmin.adminAndNormalUserLogin);

// log out
router.get('/logout',jwtHelper.verifyJwtToken,ctrlAdmin.logout);

// fetch NormalUser for Admin
router.get('/fetchNormalUserForAdmin',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('readAny','profile'),ctrlAdmin.fetchNormalUserForAdmin);

//fetch Admin

router.get('/fetchOwnProfile',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('readOwn','profile'),ctrlAdmin.fetchOwnProfile);

// add profile pic 
router.put('/updateProfilePic',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('updateOwn','profile'),ctrlAdmin.updateProfilePic);


//************************* User Section *****************************************/

//register user 
router.post('/registerUser',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('createAny','user'),ctrlUser.userRegister);

//fetch user 
router.get('/fetchAllUser',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('readAny','user'),ctrlUser.fetchAllUser);


//fetch based on category and gender
router.get('/fetchMaleAndFemaleUser/:category/:gender',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('readAny','user'),ctrlUser.fetchUserMaleAndFemale);


//update user
router.put('/updateUserProfile/:id',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('updateAny','user'),ctrlUser.updateUserProfile);

//delete user 
router.delete('/deleteUser/:id',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('deleteAny','user'),ctrlUser.deleteUser);

//update like
router.put('/updateLike/:id',jwtHelper.verifyJwtToken,ctrlUser.updateLike);

//update Dislike
router.put('/updateDisLike/:id',jwtHelper.verifyJwtToken,ctrlUser.updateDisLike);

/**************************** Request Section  ********************************* */
//create requests
router.post('/createRequest',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('createOwn','request'),ctrlAdmin.createRequest);

// show own request
router.get('/fetchOwnRequest',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('readOwn','request'),ctrlAdmin.showOwnRequests);

//show requests
router.get('/showRequests',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('readAny','request'),ctrlAdmin.showRequests);

// delete created request 

router.delete('/deleteRequest/:id',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('deleteOwn','request'),ctrlAdmin.deleteRequests);

//approve
router.put('/approveOrRejectRequest/:id',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('updateAny','request'),ctrlAdmin.acceptOrRejectRequests);


//**************************** Event Section **************************************/
//register event
router.post('/registerEvent',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('createAny','event'),ctrlEvent.registerEvent);

//show events
router.get('/showEvents/:closed',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('readAny','event'),ctrlEvent.showEvents);

// fetch image
//router.get('/imagePath/:id',ctrlEvent.fetchImageEvent);

//update events profile pic
router.put('/updateEventProfilePic/:id',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('updateAny','event'),ctrlEvent.updateEventProfilePicOrBoth);

// update event profile
router.put('/updateEventProfile/:id',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('updateAny','event'),ctrlEvent.updateEventProfile);


//delete events
router.delete('/deleteEvent/:id',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('deleteAny','event'),ctrlEvent.deleteEvent);

//show remainig time and tell closed or expired date
router.get('/showRemaingTimeAndExpiredDate/:id',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('readAny','event'),ctrlEvent.showRemainingTimeAndExpried);



//************************ Computation Post ******************************************/
//register comput posts
router.post('/registerComputationPost',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('createAny','computationalPost'),ctrlComputPost.addComputationPost);

//show posts
router.get('/showComputationPosts/:eventForComputation',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('readAny','computationalPost'),ctrlComputPost.showComputationPosts);

//update like when it clicks
router.put('/updateNumberOfLikes/:id',jwtHelper.verifyJwtToken,ctrlComputPost.updateNumberOfLikes);

//update number of dis like
router.put('/updateNumberOfDisLikes/:id',jwtHelper.verifyJwtToken,ctrlComputPost.updateNumberOfDisLikes);

//to delete posts
router.delete('/deleteComputationPost/:id',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('deleteAny','computationalPost'),ctrlComputPost.deletePost);

//fill juge points
router.put('/fillJugePoints/:id',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('updateAny','computationalPost'),ctrlComputPost.fillJugePoints);


//to show posts based on number of likes and juge points
router.get('/higherToLowerLikes/:eventForComputation',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('readAny','computationalPost'),ctrlComputPost.orderByHighestLikeToTheEvent);

//show best 3 winners
router.get('/showBestThreeWinners/:eventForComputation',jwtHelper.verifyJwtToken,ctrlAdmin.grantAccess('readAny','computationalPost'),ctrlComputPost.notifyBestThreeWinners);


//************************ Forgot Password ******************************************/
//forgot password
router.post('/resetPassword',ctrlAdmin.forgotPassword);

//validate token
router.post('/validateToken',ctrlAdmin.validateToken);

// new password
router.post('/newPassword',ctrlAdmin.newPassword);


module.exports = router;
