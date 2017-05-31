module.exports = function(nightmare, t) {
  nightmare
  .goto('http://localhost:4000')
  .visible('.liked')
  .then(function(result) {
    t.assert(result, false, "Liked class should not exist");
    return nightmare
      .click(".like")
      .wait(800)
      .visible("#resource_feedback_feedback")
      .then(function(result) {
        t.assert(result, true, "Feedback box should be visible after like click")
        return nightmare
          .visible(".liked")
          .then(function(result) {
            t.assert(result, true, "Liked class should now exist")
          })
      })
  })
  .then(t.endTests)
  .catch(t.errFunc)
}
