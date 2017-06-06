var selectedFilters = {
  category: {},
  audience: {},
  content: {}
}

if (isNotIE8()) {
  module.exports = (function(){
    // Overlay when sidebar is open
    select(".sidebar-overlay").addEventListener('click', function() {
      select("#filter_filter").checked = false;
      select("body").classList.remove("stop-scrolling");
    });
    select(".sidebar-overlay").classList.add("sidebar-overlay-js");

    // Stops main page scrolling when sidebar open
    select("#filter_filter").addEventListener('click', function() {
      select("body").classList.toggle("stop-scrolling");
    });

    // Moves buttons to bottom of sidebar
    select(".sidebar-buttons").classList.add("mt5");

    // Displays orange arrows on select box
    selectAll(".fa-down").forEach(function(el) {
      el.classList.remove("filter-arrow-hide");
    });

    // Event listeners and CSS for scrollable filter boxes
    ["category", "audience", "content"].forEach(function(el) {
      var filterType = select("." + el + "-filters");
      var filterSelect = select(".select-" + el + "-filters");
      var sidebar = select(".sidebar");

      filterType.classList.add("hide-filters", "br1", "w-100", "absolute", "bg-white", "z-1", "overflow-scroll");
      filterSelect.classList.add("select-filters", "pointer");

      filterSelect.addEventListener("click", function() {
        toggleClasses(filterType, ["hide-filters", "shadow-2", "h45"])
        toggleArrows(el);

        sidebar.addEventListener("click", function hideFilters(e) {
          updateSelected(select("#filter-form"));
          displaySelected(el);
          if (e.path.indexOf(filterSelect) == -1 && e.path.indexOf(filterType) == -1){
            toggleArrows(el);
            filterType.classList.add("hide-filters");
            filterType.classList.remove("shadow-2", "h45");
            sidebar.removeEventListener("click", hideFilters);
          }
        });
      });

      // Clicking 'Show Everything' deselects all other filters
      select(".show-everything-" + el).addEventListener("click", function() {
        selectAll(".filters-" + el).forEach(function(elem) {
          elem.checked = false;
        })
      });

      // Clicking any other filter deselects 'Show Everything'
      selectAll(".filters-" + el).forEach(function(elem){
        elem.addEventListener("click", function() {
          select(".show-everything-" + el).checked = false;
        });
      });

      updateSelected(select("#filter-form"));
      displaySelected(el);
    });
  })();
}

function toggleArrows(type) {
  toggleClasses(select(".select-" + type + "-filters > h5 > .fa-up"), ["filter-arrow-hide"]);
  toggleClasses(select(".select-" + type + "-filters > h5 > .fa-down"), ["filter-arrow-hide"]);
 }

function updateSelected(form) {
  var formData = getFormData(form)

  for (var value in formData) {
    var typeValue = value.split("[");

    if (typeValue.length === 2 ) {
      selectedFilters[typeValue[0]][typeValue[1].slice(0, -1)] = formData[value];
    }
  }
}

function displaySelected(el) {
  var selected = [];
  var exclude = ["all-category", "all-audience", "all-content"];

  for (var tag in selectedFilters[el]) {
    if(selectedFilters[el][tag] && exclude.indexOf(tag) === -1) {
      selected.push(tag);
    }
  }

  if (selected.length === 1) {
    select("." + el + "-filters-header").innerText = selected[0].split("-").join(" ");
  } else if (selected.length > 1) {
    select("." + el + "-filters-header").innerText = selected.length + " filters selected";
  } else {
    select("." + el + "-filters-header").innerText = "Select as many as are relevant";
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
