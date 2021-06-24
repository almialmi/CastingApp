const AccessControl = require("accesscontrol");
const ac = new AccessControl();
 
exports.roles = (function() {

ac.grant("NormalUser")
  .readOwn("profile")
  .updateOwn("profile")
  .createOwn("request")
  .readOwn("request")
  .updateOwn("request")
  .deleteOwn("request")
  .readAny("event")
  .readAny("category")
  .readAny("computationalPost")

 
ac.grant("Admin")
  .extend("NormalUser")
  .readAny("profile")
  .readAny("request")
  .updateAny("request")
  .createAny("user")
  .readAny("user")
  .updateAny("user")
  .deleteAny("user")
  .createAny("event")
  .updateAny("event")
  .deleteAny("event")
  .createAny("category")
  .updateAny("category")
  .deleteAny("category")
  .createAny("computationalPost")
  .updateAny("computationalPost")
  .deleteAny("computationalPost")
 
return ac;
})();