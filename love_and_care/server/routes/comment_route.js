const express = require("express");
const router = express.Router();

const { User } = require("../models/user_model");
const { Opportunity } = require("../models/opportunity_model");
const { Comment, validateComment } = require("../models/comment_model");
const validateObjectId = require("../middleware/validateObjectId");

const authenticate = require("../middleware/authorization");
const _ = require("lodash");

router.get("/:opportunityId", async (req, res) => {
  const comment = await Comment.find({
    opportunityId: req.params.opportunityId,
  })
    .select("-__v")
    .sort({ date: 1 }); // Sort by date field in ascending order

  res.send(comment);
});

router.post("/", authenticate, async (req, res) => {
  const { error } = validateComment(req.body);

  if (error) {
    var message = {
      message: `${error.details[0].message}`,
    };
    return res.status(400).send(message);
  }

  let opportunity = await Opportunity.findById(req.body.opportunityId);
  if (opportunity == null) {
    var message = {
      message: `Opportunity does not exist`,
    };
    return res.status(400).send(message);
  }

  const comment = new Comment({
    username: req.user.username,
    opportunityId: req.body.opportunityId,
    comment: req.body.comment,
  });

  const result = await comment.save();

  const response = {
    username: result.username,
    opportunityId: result.opportunityId,
    comment: result.comment,
    _id: result._id,
    date: result.date,
  };

  res.send(response);
});

router.put("/:id", validateObjectId, authenticate, async (req, res) => {
  let comment = await Comment.findById(req.params.id);
  if (!comment) {
    var message = {
      message: "The Comment with the given ID was not found.",
    };
    return res.status(404).send(message);
  }
  let opportunity = await Opportunity.findById(comment.opportunityId);
  if (!opportunity) {
    var message = {
      message: "The opportunity was not found.",
    };
    return res.status(404).send(message);
  }

  if (req.user.username == comment.username) {
    await Comment.findByIdAndUpdate(req.params.id, {
      $set: {
        comment: req.body.comment,
      },
    });

    const response = {
      username: comment.username,
      opportunityId: comment.opportunityId,
      comment: req.body.comment,
      _id: req.params.id,
      date: comment.date,
    };

    return res.send(response);
  } else {
    var message = {
      message: "A user can not update this Comment",
    };
    return res.status(401).send(message);
  }
});

router.delete("/:id", validateObjectId, authenticate, async (req, res) => {
  const comment = await Comment.findById(req.params.id);

  if (!comment) {
    var message = {
      message: "The Comment with the given id is does not exist",
    };
    return res.status(404).send(message);
  }

  if (req.user.username == comment.username) {
    await Comment.deleteOne(comment);

    const response = {
      username: comment.username,
      opportunityId: comment.opportunityId,
      comment: comment.comment,
      _id: comment._id,
      date: comment.date,
    };

    return res.send(response);
  } else {
    var message = {
      message: "A user can not delete this Comment",
    };
    return res.status(403).send(message);
  }
});

module.exports = router;
