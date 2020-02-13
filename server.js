const express = require("express");
const bodyParser = require("body-parser");
const app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

const routes = require("./routes");
app.use("/", routes);

app.listen(process.env.PORT || 8000, function() {
  console.log("server : http://localhost:%d", this.address().port);
  console.log("stage : %s", app.settings.env);
});
