const express = require("express");
const router = express.Router();

const path = require("path");
const multer = require("multer");

const storageForDriver = multer.diskStorage({
  destination: function(req, file, callback) {
    callback(null, "images/driver");
  },

  filename: function(req, file, callback) {
    callback(null, file.originalname + "_" + path.extname(file.originalname));
  }
});

const storageForContact = multer.diskStorage({
  destination: function(req, file, callback) {
    callback(null, "images/contact");
  },

  filename: function(req, file, callback) {
    callback(null, file.originalname + "_" + path.extname(file.originalname));
  }
});

const fileFilter = function(req, file, callback) {
  if (!file.originalname.match(/\.(jpg|jpeg|png|JPG|PNG|JPEG)$/)) {
    return callback(new Error("Only jpg|jpeg|png files are allowed."), false);
  }
  callback(null, true);
};
const uploadForDriver = multer({
  storage: storageForDriver,
  fileFilter: fileFilter
});

const uploadForContact = multer({
  storage: storageForContact,
  fileFilter: fileFilter
});

router.get("/test", function(req, res) {
  res.send("Test Route");
});

router.post(
  "/driverUpload",
  uploadForDriver.single("image"),
  (req, res, next) => {
    const file = req.file;
    if (!file) {
      const error = new Error("Please upload a file");
      error.httpStatusCode = 400;
      return next(error);
    }
    res.status(200).send(file);
  }
);

router.post(
  "/contactUpload",
  uploadForContact.single("image"),
  (req, res, next) => {
    const file = req.file;
    if (!file) {
      const error = new Error("Please upload a file");
      error.httpStatusCode = 400;
      return next(error);
    }
    res.status(200).send(file);
  }
);

module.exports = router;
