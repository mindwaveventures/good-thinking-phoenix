module.exports = function(nightmare, t) {
  nightmare
    .goto("http://localhost:4000")
    .click("#filter_filter")
    .wait(".sidebar-overlay")
    .evaluate(function() {
      return document.querySelector(".category-filters").clientHeight === 0;
    })
    .then(function(result) {
      t.assert(result, true, "filter blocks not visible by default");
      return nightmare
        .click(".select-filters")
        .evaluate(function() {
          return document.querySelector(".category-filters").clientHeight > 0;
        })
        .then(function(result) {
          t.assert(result, true, "filter blocks should be visible on click");
          return nightmare
            .click(".select-category-filters")
            .click(".category-tag")
            .evaluate(function() {
              return document.querySelector(".category-filters-header").innerText;
            })
            .then(function(result) {
              t.assert(result, "insomnia", "title should reflect selected filters");
            })
        })
    })
    .then(t.endTests)
    .catch(t.errFunc)
}
