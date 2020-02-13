const express = require("express");
const router = express.Router();

const moment = require("moment");
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

const low = require("lowdb");
const FileAsync = require("lowdb/adapters/FileAsync");

const driverAdapter = new FileAsync("./data/driver/driverDB.json");
const contactAdapter = new FileAsync("./data/contact/contactDB.json");

router.get("/test", function(req, res) {
  res.send("Test Route");
});

low(driverAdapter).then(driverDB => {
  low(contactAdapter).then(contactDB => {
    const driver = driverDB.get("driver").value();
    const contact = contactDB.get("contact").value();

    router.post(
      "/driverUpload",
      uploadForDriver.single("image"),
      (req, res, next) => {
        const file = req.file;
        let { firstname, lastname } = req.body;

        if (!file) {
          const error = new Error("Please upload a file");
          error.httpStatusCode = 400;
          return next(error);
        }
        driverDB
          .get("driver")
          .push({
            firstname: firstname,
            lastname: lastname,
            lastModified: moment().format("MMMM Do YYYY, h:mm:ss a")
          })
          .last()
          .assign({ id: Date.now().toString() })
          .write();
        res.status(200).send(file);
      }
    );

    router.post(
      "/contactUpload",
      uploadForContact.single("image"),
      (req, res, next) => {
        const file = req.file;
        let { firstname, lastname, phone } = req.body;

        if (!file) {
          const error = new Error("Please upload a file");
          error.httpStatusCode = 400;
          return next(error);
        }
        contactDB
          .get("contact")
          .push({
            firstname: firstname,
            lastname: lastname,
            phone: phone,
            lastModified: moment().format("MMMM Do YYYY, h:mm:ss a")
          })
          .last()
          .assign({ id: Date.now().toString() })
          .write();
        res.status(200).send(file);
      }
    );
  });
});

module.exports = router;
