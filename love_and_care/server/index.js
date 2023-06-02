const mongoose = require("mongoose");
const express = require("express");
const app = express();
const users = require("./routes/user_route");
const opportunity = require("./routes/opportunity_route");
const comment = require("./routes/comment_route");

const cors = require("cors");
const bodyParser = require("body-parser");
const config = require("config");

if (!config.get("jwtPrivateKey")) {
  throw new Error("FATAL ERROR: jwtPrivateKey is not defined.");
}

mongoose
  .connect("mongodb://0.0.0.0:27017/")
  .then(() => console.log("Database Connected"))
  .catch((err) => console.log(err));

app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use("/api/users", users);
app.use("/api/opportunity", opportunity);
app.use("/api/comment", comment);

const port = process.env.PORT || 8080;

app.listen(port, () => console.log(`Listening to port: ${port}`));
