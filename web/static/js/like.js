if (isNotIE8()) {
  module.exports = (function() {
    selectAll(".like-form", ".dislike-form", ".resource-feedback").forEach(function(el) {
      el.addEventListener("submit", formListener);
    });
  })();

  function formListener(e) {
      e.preventDefault();
      makePhoenixFormRequest("POST", e.target, function(err, res) {
        var response = JSON.parse(res);
        var resource = select("#resource_" + response.id);

        resource.innerHTML = response.result;
        resource.addEventListener("submit", formListener);
      });
  };
}
