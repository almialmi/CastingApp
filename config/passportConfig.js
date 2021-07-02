const passport = require('passport');
const Admin = require('../models/admin.models');
const CookieStrategy= require('passport-cookie');
const SECRET = process.env.JWT_SECRET

/*const opts={
    jwtFromRequest:ExtractJwt.fromAuthHeaderAsBearerToken(),
    secretOrKey: SECRET

}*/

/*module.exports = passport =>{
    passport.use(
        new Strategy(opts,async(payload,done)=>{
        await Admin.findById(payload.admin_id)
        .then(admin =>{
            if(admin){
                return done(null,admin);
            }
            return done(null,false);
        })
        .catch(err =>{
            return done(null,false);
        });
    })
    );
}*/

module.exports = passport =>{
    passport.use(
        new CookieStrategy({
            cookieName:'token',
            signed:false,
            passReqToCallback: true,
            secretOrPublicKey: SECRET
        },async(payload,done)=>{
           await Admin.findById(payload.admin_id,function(err,admin){
                if(err){
                    return done(err)
                }
                if(!admin){
                    return done(null,false)
                }
                return done(null,admin);
            })
        })
    );
}