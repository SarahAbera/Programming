const jwt = require("jsonwebtoken");
const config = require("config");

module.exports = function (req, res, next) {
  const token = req.header("x-auth-token");
  if (!token) {
    var message = {
      message: "Access denied, invalid token.",
    };
    return res.status(401).send(message);
  }

  try {
    const decoded = jwt.verify(token, config.get("jwtPrivateKey"));
    req.user = decoded;
    next();
  } catch (ex) {
    var message = {
      message: "Access denied, invalid token.",
    };
    res.status(400).send(message);
  }
};
