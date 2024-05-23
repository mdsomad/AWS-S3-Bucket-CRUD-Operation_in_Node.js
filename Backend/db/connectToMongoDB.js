const mongoose = require("mongoose");
const colors = require("colors");

const connectToMongoDB = async () => {
  try {
    //* 👇 Database Name
    const DB_OPTIONS = {
      dbName: "s3",
    };
    await mongoose.connect(process.env.MONGO_DB_URI, DB_OPTIONS);
    console.log("Connected to Successfully MongoDB ✅".rainbow);
  } catch (error) {
    console.log("Error connecting to MongoDB ⚠️".red, error.message);
  }
};


module.exports = connectToMongoDB;
