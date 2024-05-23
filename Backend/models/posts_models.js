const mongoose = require("mongoose");

const postsSchema = new mongoose.Schema(
  {
    imageUrl: [
      {
        type: String,
        // required: true,
      },
    ],
    fileName: [
      {
        type: String,
        // required: true,
      },
    ],
    //* createdAt, updatedAt => Member since <createdAt>
  },
  { timestamps: true }
);

const Posts = mongoose.model("Posts", postsSchema);

module.exports = Posts;
