module.exports = function(nightmare, t) {
  var resources;
  nightmare
    .goto("http://localhost:4000")
    .visible("#results")
    .then(function(result) {
      t.assert(result, true);
    })
    .then(function () {
      return nightmare
        .evaluate(function () {
          return [].filter.call(document.querySelectorAll('#results > div > div'), function (el) {
            return el.id.substring(0, 9) === 'resource_' && el.className.indexOf('dn') === -1;
          }).length
        });
    })
    .then(function (result) {
      t.assert(result, 5);
    })
    .then(function () {
      return nightmare
        .evaluate(function () {
          return document.querySelector('#see_more').className.indexOf('dn-important') === -1;
        });
    })
    .then(function (result) {
      t.assert(result, true);
    })
    .then(function () {
      return nightmare
        .click('#see_more')
        .evaluate(function () {
          return [].filter.call(document.querySelectorAll('#results > div > div'), function (el) {
            return el.id.substring(0, 9) === 'resource_' && el.className.indexOf('dn') === -1;
          }).length > 5
        });
    })
    .then(function (result) {
      t.assert(result, true);
    })
    .then(function () {
      return nightmare
        .evaluate(function () {
          return document.querySelector('#see_more').className.indexOf('dn-important') !== -1;
        });
    })
    .then(function (result) {
      t.assert(result, true);
    })
    .then(t.endTests)
    .catch(t.errFunc)
}
