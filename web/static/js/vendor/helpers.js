// Helper function to toggle multiple classes on an element
function toggleClasses(element, classes) {
  classes.forEach(function(c) {
    element.classList.toggle(c);
  });
}

// Aliases for querySelector functions
function select(query) {
  return document.querySelector(query);
}

function selectAll() {
  if (arguments.length > 1) {
    var selected = [];

    Array.prototype.forEach.call(arguments, function(query) {
      selected = selected.concat(Array.prototype.slice.call(document.querySelectorAll(query)));
    });

    return selected;
  } else {
    return Array.prototype.slice.call(document.querySelectorAll(arguments[0]));
  }
}

// Site is fully functional without javascript
// so if these methods do not exist (Internet Explorer 8 & unsupported browsers)
// fall back to non-javascript
// https://www.gov.uk/service-manual/technology/designing-for-different-browsers-and-devices
function isNotIE8() {
  return Element.prototype.addEventListener && Array.prototype.forEach;
}

// Make an AJAX request with a Phoenix form using the csrf value of that form
function makePhoenixFormRequest(type, form, callback) {
  var request = new XMLHttpRequest();
  var url = form.action;
  var csrf = form.children["_csrf_token"].value;

  request.addEventListener('load', function (e) {
    return callback(null, this.responseText);
  });

  request.open(type, url);

  request.setRequestHeader('accept', 'application/json');
  request.setRequestHeader("x-csrf-token", csrf);
  request.send();
}
