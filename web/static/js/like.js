module.exports = (function() {
  selectAll(".like-form", ".dislike-form").forEach(function(el) {
    el.addEventListener("submit", function(e) {
      e.preventDefault();
      makePhoenixFormRequest("POST", e.target, function(err, res) {
        var response = JSON.parse(res);
        var button = select("#" + response.value + "-" + response.id + " button");
        var count = select("#" + response.value + "-count-" + response.id);
        var oppositeValue = response.value === "like" ? "dislike" : "like";
        var oppositeButton = select("#" + oppositeValue + "-" + response.id + " button");
        var oppositeCount = select("#" + oppositeValue + "-count-" + response.id);

        toggleClasses(button, [response.value, response.value + "d"]);

        if (oppositeButton.classList.contains(oppositeValue + "d")) {
          toggleClasses(oppositeButton, [oppositeValue, oppositeValue + "d"]);
          oppositeCount.innerText = decCount(oppositeValue, oppositeCount.innerText)
        }

        if (button.classList.contains(response.value)) {
          count.innerText = incCount(oppositeValue, count.innerText)
        } else {
          count.innerText = decCount(oppositeValue, count.innerText)
        }
      });
    });
  });
})();

function incCount(value, count) {
  return value === "like" ? parseInt(count) + 1 : parseInt(count) -1;
}

function decCount(value, count) {
  return value === "like" ? parseInt(count) - 1 : parseInt(count) + 1;
}
