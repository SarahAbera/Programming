const mongoose = require("mongoose");
const Joi = require("joi");

const config = require("config");
const jwt = require("jsonwebtoken");

const userSchema = new mongoose.Schema({
  username: {
    type: String,
    required: true,
    maxlength: 50,
    unique: true,
  },
  role: {
    type: String,
    required: true,
    maxlength: 50,
  },
  email: {
    type: String,
    required: true,
    maxlength: 255,
    unique: true,
  },
  password: {
    type: String,
    required: true,
    maxlength: 1024,
  },
  phoneNumber: {
    type: String,
    maxlength: 15,
  },
  address: {
    type: String,
    maxlength: 255,
  },
  skills: {
    type: String,
    maxlength: 500,
  },
  interests: {
    type: String,
    maxlength: 255,
  },
  about: {
    type: String,
    maxlength: 1000,
  },
  default: false,
});

userSchema.methods.generateAuthToken = function () {
  const token = jwt.sign(
    { _id: this._id, role: this.role, username: this.username },
    config.get("jwtPrivateKey")
  );
  return token;
};

const User = mongoose.model("User", userSchema);

function validateUserRegister(user) {
  const schema = Joi.object({
    username: Joi.string().max(50).required(),
    role: Joi.string().max(50).required(),
    email: Joi.string().max(255).required().email(),
    password: Joi.string().max(1024).required(),
  });
  return schema.validate(user);
}
function validateUserLogging(user) {
  const schema = Joi.object({
    email: Joi.string().max(255).required().email(),
    password: Joi.string().max(1024).required(),
  });
  return schema.validate(user);
}

exports.User = User;
exports.validateUserRegister = validateUserRegister;
exports.validateUserLogging = validateUserLogging;
