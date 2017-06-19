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
        analytics.addAnalytics(select("button[name='like']", resource), "Like", "liked");
        analytics.addAnalytics(select("button[name='dislike']", resource), "Dislike", "disliked");
        analytics.addAnalytics(select(".share", resource), "Share", "shared");
        analytics.addAnalytics(select(".resource-feedback", resource), "ResourceFeedback", "reviewed");
        handle_ios();
      });
    }
  };
}

function handle_ios_likes (like) {
  selectAll("button[name='" + like + "']").forEach(function (el) {
    if (el.className.indexOf(like + '_no_hover') === -1) {
      toggleClasses(el, [like, like + '_no_hover'])
    }
  });
}

function handle_ios () {
  if (navigator.platform && /iPad|iPhone|iPod/.test(navigator.platform)) {
    ['like', 'dislike'].forEach(handle_ios_likes);
  }
}

handle_ios();
