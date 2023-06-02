const mongoose = require("mongoose");
const Joi = require("joi");

const CommentSchema = new mongoose.Schema(
  {
    username: {
      type: String,
      ref: "User",
      required: true,
    },
    opportunityId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Opportunity",
      required: true,
    },

    comment: {
      type: String,
      required: true,
      maxlength: 2048,
    },
    date: {
      type: Date,
      required: true,
      default: Date.now,
    },
  },
  { versionKey: false }
);

const Comment = mongoose.model("Comment", CommentSchema);

function validateComment(comment) {
  const schema = Joi.object({
    opportunityId: Joi.string().required(),
    comment: Joi.string().required(),
  });
  return schema.validate(comment);
}

exports.Comment = Comment;
exports.validateComment = validateComment;
