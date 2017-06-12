var analytics = require("./analytics");

if (isNotIE8()) {
  module.exports = (function() {
    selectAll([".like-form", ".dislike-form", ".resource-feedback"]).forEach(function(el) {
      el.addEventListener("submit", formListener);
    });
  })();

  function formListener(e) {
    if (FormData) {
      e.preventDefault();
      makePhoenixFormRequest("POST", e.target, function(err, res) {
        var response = JSON.parse(res);
        var resource = select("#resource_" + response.id);

        resource.innerHTML = response.result;
        resource.addEventListener("submit", formListener);
        analytics.addAnalytics(select(".like", resource), "Like", "liked");
        analytics.addAnalytics(select(".dislike", resource), "Dislike", "disliked");
        analytics.addAnalytics(select(".share", resource), "Share", "shared");
        analytics.addAnalytics(select(".resource-feedback", resource), "ResourceFeedback", "reviewed");
      });
    }
  };
}
