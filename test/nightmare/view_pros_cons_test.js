module.exports = function(nightmare, t) {
  nightmare
    .goto("http://localhost:4001")
    .viewport(200, 300)
    .visible("#see_more")
    .then(function(result) {
      t.assert(result, true, "See more visible")
      return nightmare
        .click("#see_more")
        .wait(1000)
        .visible(".view_pcs")
        .then(function(result) {
          t.assert(result, true, "View pros cons button visible")
          return nightmare
            .visible(".pros_cons")
            .then(function(result) {
              t.assert(result, false, "Pros & cons are not visible before clicking button")
              return nightmare
                .click(".view_pcs")
                // have long wait so you can scroll down to view it on the screen
                .wait(1000)
                .visible(".pros_cons")
                .then(function(result) {
                  t.assert(result, true, "Pros & cons visible after clicking")
                })
            })
        })
    })
    .then(t.endTests)
    .catch(t.errFunc)
}
