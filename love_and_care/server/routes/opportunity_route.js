const express = require("express");
const router = express.Router();
const { Comment } = require("../models/comment_model"); // Assuming you have a Comment model defined

const {
  Opportunity,
  validateOpportunity,
} = require("../models/opportunity_model");
const authenticate = require("../middleware/authorization");
const validateObjectId = require("../middleware/validateObjectId");

const FormatOpportunity = (opportunity) => {
  const formattedOpportunity = {
    _id: opportunity._id,
    username: opportunity.userId.username,
    title: opportunity.title,
    description: opportunity.description,
    location: opportunity.location,
    date: opportunity.date,
    totalLikes: opportunity.totalLikes,
    totalParticipants: opportunity.totalParticipants,
    likes: opportunity.likes,
    participants: opportunity.participants,
  };
  return formattedOpportunity;
};

const _ = require("lodash");
router.get("/", async (req, res) => {
  const opportunities = await Opportunity.find()
    .select("-__v")
    .populate("userId", "username")
    .lean();

  const formattedOpportunities = opportunities.map((opportunity) =>
    FormatOpportunity(opportunity)
  );

  res.send(formattedOpportunities.reverse());
});

router.get("/:id", validateObjectId, async (req, res) => {
  let opportunity = await Opportunity.findById(req.params.id)
    .select("-__v")
    .populate("userId", "username")
    .lean();
  if (!opportunity) return res.status(404).send({ message: "Invalid Id" });

  res.send(FormatOpportunity(opportunity));
});

router.get("/user/events", authenticate, async (req, res) => {
  let opportunities = await Opportunity.find()
    .select("-__v")
    .populate("userId", "username")
    .lean();

  opportunities = opportunities.filter(
    (x) => x.userId.username == req.user.username
  );

  const formattedOpportunities = opportunities.map((opportunity) =>
    FormatOpportunity(opportunity)
  );

  res.send(formattedOpportunities.reverse());
});

router.get("/user/participated", authenticate, async (req, res) => {
  try {
    let opportunities = await Opportunity.find()
      .select("-__v")
      .populate("userId", "username")
      .lean();
    opportunities = opportunities.filter((op) =>
      op.participants.includes(req.user.username)
    );

    const formattedOpportunities = opportunities.map((opportunity) =>
      FormatOpportunity(opportunity)
    );
    res.send(formattedOpportunities);
  } catch (error) {
    res.status(500).send("An error occurred while fetching the opportunities.");
  }
});

router.put("/participate/:id", authenticate, async (req, res) => {
  const username = req.user.username;
  try {
    let opportunity = await Opportunity.findById(req.params.id).populate(
      "userId",
      "username"
    );

    if (!opportunity) {
      return res.status(404).send("Invalid Id");
    }

    const participantIndex = opportunity.participants.indexOf(username);
    if (participantIndex !== -1) {
      opportunity.participants.splice(participantIndex, 1);
      opportunity.totalParticipants--;
    } else {
      opportunity.participants.push(username);
      opportunity.totalParticipants++;
    }

    await opportunity.save();

    res.send(FormatOpportunity(opportunity));
  } catch (error) {
    console.log(error);
    res.status(500).send({ message: "Server Error" });
  }
});

router.put("/like/:id", authenticate, async (req, res) => {
  const username = req.user.username;
  try {
    let opportunity = await Opportunity.findById(req.params.id).populate(
      "userId",
      "username"
    );
    if (!opportunity) {
      return res.status(404).send("Invalid Id");
    }

    const participantIndex = opportunity.likes.indexOf(username);
    if (participantIndex !== -1) {
      opportunity.likes.splice(participantIndex, 1);
      opportunity.totalLikes--;
    } else {
      opportunity.likes.push(username);
      opportunity.totalLikes++;
    }
    await opportunity.save();

    res.send(FormatOpportunity(opportunity));
  } catch (error) {
    console.log(error);
    res.status(500).send({ message: "Server Error" });
  }
});

router.post("/", authenticate, async (req, res) => {
  const { error } = validateOpportunity(req.body);

  if (error) {
    var message = {
      message: `${error.details[0].message}`,
    };
    return res.status(400).send(message);
  }
  let opportunity = new Opportunity({
    userId: req.user._id,
    title: req.body.title,
    description: req.body.description,
    date: req.body.date,
    time: req.body.time,
    location: req.body.location,
  });

  const result = await opportunity.save();
  opportunity = await Opportunity.findById(result._id).populate(
    "userId",
    "username"
  );

  res.send(FormatOpportunity(opportunity));
});

router.put("/:id", validateObjectId, authenticate, async (req, res) => {
  const { error } = validateOpportunity(req.body);
  if (error) {
    var message = {
      message: `${error.details[0].message}`,
    };
    return res.status(400).send(message);
  }

  let opportunity = await Opportunity.findById(req.params.id);
  if (!opportunity) {
    var message = {
      message: "The Opportunity with the given ID was not found.",
    };
    return res.status(404).send(message);
  }

  if (req.user._id == opportunity.userId) {
    await Opportunity.findByIdAndUpdate(req.params.id, {
      $set: {
        title: req.body.title,
        description: req.body.description,
        date: req.body.date,
        location: req.body.location,
      },
    });

    opportunity = await Opportunity.findById(req.params.id).populate(
      "userId",
      "username"
    );

    res.send(FormatOpportunity(opportunity));
  } else {
    var message = {
      message: "A user can not update this Opportunity",
    };
    return res.status(401).send(message);
  }
});

// ...

router.delete("/:id", validateObjectId, authenticate, async (req, res) => {
  try {
    let opportunity = await Opportunity.findById(req.params.id).populate(
      "userId",
      "username"
    );
    if (!opportunity) {
      var message = {
        message: "The Opportunity with the given id does not exist",
      };
      return res.status(404).send(message);
    }
    if (req.user._id.toString() === opportunity.userId._id.toString()) {
      // Delete the opportunity
      await Opportunity.deleteOne(opportunity);

      // Delete comments associated with the opportunity
      await Comment.deleteMany({ opportunityId: opportunity._id });

      res.send(FormatOpportunity(opportunity));
    } else {
      var message = {
        message: "A user cannot delete this Opportunity",
      };
      return res.status(403).send(message);
    }
  } catch (error) {
    return res
      .status(500)
      .send({ message: "An error occurred while deleting the Opportunity" });
  }
});

module.exports = router;
