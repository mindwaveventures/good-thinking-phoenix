module.exports = function(nightmare, t) {
  nightmare
    .goto('http://localhost:4001')
    .scrollTo(100, 0)
    .evaluate(function() {
      return document.querySelector('#beta-banner').style.backgroundColor;
    })
    .then(function(result) {
      t.assert(result, 'white');
    })
    .then(t.endTests)
    .catch(t.errFunc)
}
