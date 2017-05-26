module.exports = function(nightmare, t) {
  nightmare
    .goto("http://localhost:4000")
    .visible(".sidebar-overlay")
    .then(function(result) {
      t.assert(result, false);
      return nightmare
        .click("#filter_filter")
        .visible(".sidebar-overlay")
        .then(function(result) {
          t.assert(result, true, "sidebar should be visible")
          return nightmare
            .click(".sidebar-overlay")
            .visible(".sidebar-overlay")
            .then(function(result) {
              t.assert(result, false, "Clicking overlay should close sidebar")
            })
        })
    })
    .then(t.endTests)
    .catch(t.errFunc)
}
