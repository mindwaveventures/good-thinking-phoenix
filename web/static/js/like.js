if (isNotIE8()) {
  module.exports = (function() {
    selectAll(".like-form", ".dislike-form").forEach(function(el) {
      el.addEventListener("submit", formListener);
    });
  })();

  function formListener(e) {
    if (e.target.classList.contains("like-form") || e.target.classList.contains("dislike-form"))
    e.preventDefault();
    makePhoenixFormRequest("POST", e.target, function(err, res) {
      var response = JSON.parse(res);
      var resource = select("#resource_" + response.id);

      resource.innerHTML = response.result;
      resource.addEventListener("submit", formListener);
    });
  };
}
