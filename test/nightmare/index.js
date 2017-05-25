var fs = require('fs');
var Nightmare = require('nightmare');

var test = function(file, nightmare) {
  return {
    assert: function(a, b, message) {
      if (a == b) {
        return true
      } else {
        var printMessage = "FAIL\n" + file + " -> " + message + "\n" +
                           "Expected: " + b +  ", Actual: " + a;

        console.error(printMessage);
        process.exit(1);
      }
    },

    endTests: function() {
      console.log("All tests pass:", file);
      return nightmare.end();
    },

    errFunc: function(error) {
      console.error(file);
      console.error("failed:", error);
      process.exit(1);
    }
  }
}

fs.readdir(__dirname, function(err, files) {
  if (err) return errFunc("index.js", err);

  files.forEach(function(file) {
    var nightmare = Nightmare({ show: true });

    if (file !== "index.js") {
      require('./' + file)(nightmare, test(file, nightmare));
    }
  });
})
