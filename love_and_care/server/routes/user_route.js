const express = require("express");
const router = express.Router();
const {
  User,
  validateUserRegister,
  validateUserLogging,
} = require("../models/user_model");
const _ = require("lodash");
const config = require("config");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const authorize = require("../middleware/authorization");
const validateObjectId = require("../middleware/validateObjectId");
const authenticate = require("../middleware/authorization");

router.get("/:username", async (req, res) => {
  let user = await User.findOne({ username: req.params.username }).select(
    "-__v -password"
  );

  if (!user) return res.status(404).send({ message: "Invalid User Id" });
  const response = {
    id: user.id,
    username: user.username,
    email: user.email,
    role: user.role,
    phoneNumber: user.phoneNumber || "",
    address: user.address || "",
    skills: user.skills || "",
    interests: user.interests || "",
    about: user.about || "",
    token: user.generateAuthToken(),
  };
  res.send(response);
});

router.put("/:id", validateObjectId, authenticate, async (req, res) => {
  let user = await User.findById(req.params.id).select("-__v -password");

  if (!user) return res.status(404).send({ message: "Invalid Id" });

  console.log("user id: ", req.user._id);
  console.log("user: ", user);

  if (req.user._id == req.params.id) {
    await User.findByIdAndUpdate(req.params.id, {
      $set: {
        phoneNumber: req.body?.title || user?.username,
        address: req.body?.address || user?.address,
        skills: req.body?.skills || user?.skills,
        interests: req.body?.interests || user?.interests,
        about: req.body?.about || user?.about,
      },
    });

    user = await User.findById(req.params.id).select("-__v -password");

    const response = {
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role,
      phoneNumber: user.phoneNumber || "",
      address: user.address || "",
      skills: user.skills || "",
      interests: user.interests || "",
      about: user.about || "",
      token: user.generateAuthToken(),
    };
    res.send(response);
  } else {
    var message = {
      message: "A user can not update profile",
    };
    return res.status(401).send(message);
  }
});

router.post("/register", async (req, res) => {
  console.log("register called");
  const { error } = validateUserRegister(req.body);
  if (error) return res.status(400).send({ message: error.details[0].message });
  let user = await User.findOne({ email: req.body.email });
  if (user) {
    var message = {
      message: "User already registered.",
    };
    return res.status(400).send(message);
  }

  user = await User.findOne({ email: req.body.username });
  if (user) {
    var message = {
      message: "username taken",
    };
    return res.status(400).send(message);
  }

  user = new User(_.pick(req.body, ["username", "email", "password", "role"]));

  const salt = await bcrypt.genSalt(10);
  user.password = await bcrypt.hash(user.password, salt);
  user = await user.save();

  const result = {
    id: user.id,
    username: user.username,
    email: user.email,
    role: user.role,
    phoneNumber: user.phoneNumber || "",
    address: user.address || "",
    skills: user.skills || "",
    interests: user.interests || "",
    about: user.about || "",
    token: user.generateAuthToken(),
  };

  res.send(result);
});

router.post("/login", async (req, res) => {
  const { error } = validateUserLogging(req.body);
  if (error) return res.status(400).send({ message: error.details[0].message });

  let user = await User.findOne({ email: req.body.email });
  if (!user) {
    var message = {
      message: "Invalid email or password",
    };
    return res.status(400).send(message);
  }

  const validPassword = await bcrypt.compare(req.body.password, user.password);
  if (!validPassword) {
    var message = {
      message: "Invalid email or password",
    };
    return res.status(400).send(message);
  }
  const result = {
    id: user.id,
    username: user.username,
    email: user.email,
    role: user.role,
    phoneNumber: user.phoneNumber || "",
    address: user.address || "",
    skills: user.skills || "",
    interests: user.interests || "",
    about: user.about || "",
    token: user.generateAuthToken(),
  };

  res.send(result);
});

router.post("/logout", async (req, res) => {
  // Remove or invalidate the user's token
  // req?.user?.token = null;
  // await req?.user.save();

  var message = {
    message: "Logout successful",
  };

  res.send(message);
});

module.exports = router;
