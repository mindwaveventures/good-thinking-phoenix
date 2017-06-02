module.exports = (function() {
  selectAll(".share").forEach(function(el) {
    addAnalytics(el, "Share", "shared");
  });

  selectAll([".like", ".dislike"]).forEach(function(el) {
    if (el.classList.contains("like")) {
      addAnalytics(el, "Like", "liked");
    } else {
      addAnalytics(el, "Dislike", "disliked");
    }
  });

  selectAll(".resource-feedback").forEach(function(el) {
    addAnalytics(el, "ResourceFeedback", "reviewed", "submit");
  });

  return {
    addAnalytics: addAnalytics
  }
})();

// Adds event listener that pushes to the data layer on click
// Expects target to have a data attribute containing the url
// of the resource it's linked to
function addAnalytics(el, analyticsEvent, analyticsVar, action) {
  if (el) {
    el.addEventListener(action || "click", function(e) {
      var variableData = {};
      variableData[analyticsVar] = e.target.getAttribute("data-url");

      dataLayer.push(variableData);
      dataLayer.push({"event": analyticsEvent});
    });
  }
}
