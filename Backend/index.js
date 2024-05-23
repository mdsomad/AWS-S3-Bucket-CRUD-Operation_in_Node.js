require("dotenv").config();
const express = require("express");
const morgan = require("morgan");
const app = express();

const aws = require("aws-sdk");
require("aws-sdk/lib/maintenance_mode_message").suppress = true;
const multer = require("multer");
const multerS3 = require("multer-s3");
const Posts = require("./models/posts_models");

const connectToMongoDB = require("./db/connectToMongoDB");

app.use(morgan("dev")); //* <-- Api hit detail Terminal Mein show karta hai

aws.config.update({
  accessKeyId: process.env.ACCESS_KEY_ID,
  secretAccessKey: process.env.SECRET_ACCESS_KEY,
  region: process.env.REGION,
  //* Note: 'bucket' is not a valid AWS SDK configuration property
});

const BUCKET_NAME = process.env.BUCKET_NAME;
const s3 = new aws.S3();

const upload = multer({
  storage: multerS3({
    s3: s3,
    bucket: BUCKET_NAME,
    metadata: function (req, file, cb) {
      cb(null, { fieldName: file.fieldname });
    },
    key: function (req, file, cb) {
      console.log(req.params);
      // cb(null, Date.now().toString())
      // cb(null, file.originalname);
      cb(null, Date.now().toString() + file.originalname);
    },
    contentType: multerS3.AUTO_CONTENT_TYPE,
  }),
});

const uploadPut = multer({
  storage: multerS3({
    s3: s3,
    bucket: BUCKET_NAME,
    contentType: multerS3.DEFAULT_CONTENT_TYPE,
    metadata: function (req, file, cb) {
      cb(null, { fieldName: file.fieldname });
    },
    key: function (req, file, cb) {
      let imageUrl = req.query.ImageUrl;
      //* 👇 url sa image ka name find code
      const urlArray = imageUrl.split("/");
      const image = urlArray[urlArray.length - 1];
      const fileName = image.split("/")[0];
      console.log(`Image Name --> ${fileName}`);
      cb(null, fileName);
    },
    contentType: multerS3.AUTO_CONTENT_TYPE,
  }),
});

//TODO: File & Images Upload Function Create
app.post("/Upload", upload.single("image"), async function (req, res, next) {
  console.log(req.file);
  console.log(req.file.location);
  console.log(req.file.key);
  res.status(200).json({
    status: "success",
    message: "Successfully uploaded 🚀 ✅",
    imageUrl: req.file.location,
  });
});

//!-----------------------------------------------------------------------------------------------------------------------------------

//TODO:👇 Existing Post Single New File & Image Upload Function Create
app.post(
  "/existingPostSingleNewImageUpload",
  upload.single("image"),
  async function (req, res, next) {
    let id = req.query.id;
    console.log(req.file);
    console.log(req.file.location);
    console.log(req.file.key);

    try {
      const post = await Posts.findById(id);
      console.log(post);
      if (!post) {
        return res
          .status(404)
          .json({ status: "fail", message: "Post not found ❌" });
      }
      post.imageUrl.push(req.file.location);
      await post.save();
      res.status(200).json({
        status: "success",
        message: "Successfully Single Image uploaded 🚀 ✅",
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({
        status: "fail",
        message: "Internal Server Error ❌" + error,
      });
    }
  }
);

//TODO: Multiple Files & Images Upload Function Create
app.post(
  "/multipleUpload",
  upload.array("images", 6),
  async function (req, res, next) {
    // console.log(req.files.length);

    try {
      //* If File not found
      if (req.files === undefined) {
        console.log("uploadPostImages Error: No File Selected!");
        res.status(400).json({
          status: "fail",
          message: "Error: No File Selected ❌",
        });
      } else {
        //* If Success
        let fileArray = req.files,
          fileLocation;
        const images = [];

        //! 👇 Currently not use
        // const newPostData = {
        //   imageUrl: fileArray[0].location,
        //   fileName: fileArray[0].key,
        // };
        const newPost = await Posts.create({}); //* <-- Emty Post Craete
        console.log(newPost);
        console.log(fileArray);
        for (let i = 0; i < fileArray.length; i++) {
          fileLocation = fileArray[i].location;
          console.log("filenm 👉", fileLocation);
          images.push(fileLocation);
          newPost.imageUrl.push(fileArray[i].location); //* <-- Posts imagUrl arrey add & push
          newPost.fileName.push(fileArray[i].key); //* <-- Posts FileName arrey add & push
        }
        //*👇 Save the ImageURL Aur File name into database
        await newPost.save();
        // return res.status(200).json({
        //   status: "ok",
        //   filesArray: fileArray,
        //   locationArray: images,
        //   newPost: newPost,
        // });

        // return res.status(400).json({
        //   status: "fail",
        //   message: "Error: No File Selected Somad",
        // });

        return res.status(201).json({
          success: "Post Successfully uploaded 🚀 ✅",
          data: newPost,
        });
      }
    } catch (error) {
      return res.status(500).json({
        status: "fail",
        message: "Internal Server Error ❌" + error,
      });
    }
  }
);

//TODO: File & Images Update Function Create
app.put(
  "/singleImageUpdate",
  uploadPut.single("image"),
  async function (req, res, next) {
    console.log(req.file);
    console.log(req.file.location);
    console.log(req.file.key);
    console.log(req.query.ImageUrl);
    res.status(200).json({
      status: "success",
      message: "Successfully uploaded 🚀 ✅",
      imageUrl: req.file.location,
    });
  }
);

//TODO: File Name List Function Create
app.get("/list", async (req, res) => {
  try {
    let r = await s3.listObjectsV2({ Bucket: BUCKET_NAME }).promise();
    let x = r.Contents.map((item) => item.Key);
    res.send(x);
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      status: "fail",
      message: "Internal Server Error ❌" + error,
    });
  }
});

//TODO: File Download Function Create
app.get("/download/:filename", async (req, res) => {
  const filename = req.params.filename;
  try {
    let x = await s3
      .getObject({ Bucket: BUCKET_NAME, Key: filename })
      .promise();
    res.send(x.Body);
  } catch (error) {
    console.error(error);
    return res.status(404).json({
      status: "fail",
      message: "File & Post Not Found ❌" + error,
    });
  }
});

//TODO: All GetPosts Function Create
app.get("/getPosts", async (req, res) => {
  try {
    const post = await Posts.find().sort({ createdAt: -1 });
    const postsCount = await Posts.countDocuments();
    return res.status(200).json({ success: true, postsCount, post });
    // return res.status(400).json({
    //   status: "fail",
    //   message: "Error: No File Selected Somad",
    // });
  } catch (error) {
    console.error(error);
    return res.status(404).json({
      status: "fail",
      message: "File & Post Not Found ❌" + error,
    });
  }
});

//TODO:👇 Existing Post Single File & Image Delete Function Create
app.delete("/singleImageDelete", async (req, res) => {
  let id = req.query.id;
  let imageUrl = req.query.ImageUrl;
  console.log(imageUrl);

  try {
    const post = await Posts.findById(id);
    console.log(post);
    if (!post) {
      return res
        .status(404)
        .json({ status: "fail", message: "Post not found ❌" });
    }

    //* 👇 url sa image ka name find code
    const urlArray = imageUrl.split("/");
    const image = urlArray[urlArray.length - 1];
    const fileName = image.split("/")[0];
    console.log(`File Name --> ${fileName}`);

    if (post.imageUrl.length === 1) {
      console.log("Single item --> " + post.imageUrl.length);

      await s3.deleteObject({ Bucket: BUCKET_NAME, Key: fileName }).promise();

      await post.deleteOne();
    } else {
      console.log("Multiple item --> " + post.imageUrl.length);

      await s3.deleteObject({ Bucket: BUCKET_NAME, Key: fileName }).promise();

      const index = post.imageUrl.indexOf(imageUrl);
      post.imageUrl.splice(index, 1);
      await post.save();
    }

    return res.status(200).json({
      status: "success",
      message: "Image Delete Successfully 🚀 ✅",
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      status: "fail",
      message: "Internal Server Error ❌" + error,
    });
  }
});

//TODO: Delete Post Function Create
app.delete("/deletePost", async (req, res) => {
  let id = req.query.id;

  try {
    const post = await Posts.findById(id);
    console.log(post);
    if (!post) {
      return res
        .status(404)
        .json({ status: "fail", message: "Post not found ❌" });
    }

    for (let i = 0; i < post.imageUrl.length; i++) {
      console.log(`Database Save FileName --> ${post.fileName[i]}`);
      //* 👇 url sa image ka name find code
      const urlArray = post.imageUrl[i].split("/");
      const image = urlArray[urlArray.length - 1];
      const imageName = image.split("/")[0];
      console.log(`Image Name --> ${imageName}`);
      await s3.deleteObject({ Bucket: BUCKET_NAME, Key: imageName }).promise();
      // await s3
      // .deleteObject({ Bucket: BUCKET_NAME, Key: post.fileName[i] })
      // .promise();
    }
    await post.deleteOne();
    return res.status(200).json({
      status: "success",
      message: "File Deleted Successfully 🚀 ✅",
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      status: "fail",
      message: "Internal Server Error ❌" + error,
    });
  }
});

//TODO: Close Server function Create
app.get("/server-udado", (req, res) => {
  res.send("Server abhi udadunga jaldi");
  process.exit(0);
});

const PORT = process.env.PORT || 4000;

app.listen(PORT, function () {
  connectToMongoDB();
  console.log(`Server is working on 🚀 http://localhost:${PORT}`);
});
