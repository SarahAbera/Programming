const mongoose = require("mongoose");
const Joi = require("joi");

const opportunitySchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    title: {
      type: String,
      required: true,
      maxlength: 2048,
    },
    description: {
      type: String,
      required: true,
      maxlength: 2048,
    },
    location: {
      type: String,
      required: true,
      maxlength: 2048,
    },
    date: {
      type: Date,
      required: true,
    },
    participants: [
      {
        type: String, // Use String type to store usernames
        ref: "User",
      },
    ],
    totalParticipants: {
      type: Number,
      required: true,
      default: 0,
    },
    likes: [
      {
        type: String,
        ref: "User",
      },
    ],
    totalLikes: {
      type: Number,
      required: true,
      default: 0,
    },
  },
  { versionKey: false }
);

const Opportunity = mongoose.model("Opportunity", opportunitySchema);

function validateOpportunity(Opportunity) {
  const schema = Joi.object({
    title: Joi.string().max(2048).required(),
    description: Joi.string().max(2048).required(),
    date: Joi.date().required(),
    location: Joi.string().max(2048).required(),
  });
  return schema.validate(Opportunity);
}

exports.Opportunity = Opportunity;
exports.validateOpportunity = validateOpportunity;
