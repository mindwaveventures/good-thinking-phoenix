// Helper function to toggle multiple classes on an element
function toggleClasses(element, classes) {
  classes.forEach(function(c) {
    element.classList.toggle(c);
  });
}

function addClasses(element, classes) {
  classes.forEach(function(c) {
    element.classList.add(c);
  });
}

function removeClasses(element, classes) {
  classes.forEach(function(c) {
    element.classList.remove(c);
  });
}

// Aliases for querySelector functions
// Uses document.querySelector if no parent is passed
function select(query, parent) {
  return parent ? parent.querySelector(query) : document.querySelector(query);
}

// Takes array of queries or single query, and optional parent element
// Uses document.querySelector if no parent is passed
function selectAll(queries, parent) {
  var parentNode = parent || document;

  if (typeof queries === "object" && queries.length >= 1) {
    var selected = [];

    queries.forEach(function(query) {
      selected = selected.concat(Array.prototype.slice.call(parentNode.querySelectorAll(query)));
    });

    return selected;
  } else {
    return Array.prototype.slice.call(parentNode.querySelectorAll(queries));
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

  if (type === "POST") {
    request.send(new FormData(form));
  } else {
    request.send();
  }
}

function getFormData(form, data) {
  var formData = data || {};

  Array.prototype.slice.call(form.children).forEach(function(el) {
    if (el.nodeName === "INPUT" && el.type === "checkbox") {
      formData[el.name] = el.checked;
    } else {
      getFormData(el, formData);
    }
  });

  return formData;
}

function getResourceId(node) {
  if(node.id.indexOf('resource_') > -1) {
    return node.id.split('_')[1];
  }

  if(!node.parentNode) {
    console.log('Could not find resource_id');
    return;
  }

  return getResourceId(node.parentNode);
}
