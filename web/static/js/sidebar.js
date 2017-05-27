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
    select(".sidebar-buttons").classList.add("absolute", "bottom-2");

    // Displays orange arrows on select box
    selectAll(".fa-down").forEach(function(el) {
      el.classList.remove("filter-arrow-hide");
    });

    // Event listeners and CSS for scrollable filter boxes
    ["category", "audience", "content"].forEach(function(el) {
      var filterType = select("." + el + "-filters");
      var filterSelect = select(".select-" + el + "-filters");
      var sidebar = select(".sidebar");

      filterType.classList.add("hide-filters", "br1", "w-80", "absolute", "bg-white", "z-1", "overflow-scroll");
      filterSelect.classList.add("select-filters", "pointer");

      filterSelect.addEventListener("click", function() {
        toggleClasses(filterType, ["hide-filters", "shadow-2", "h5"])
        toggleArrows(el);

        sidebar.addEventListener("click", function hideFilters(e) {
          if (e.path.indexOf(filterSelect) == -1 && e.path.indexOf(filterType) == -1){
            toggleArrows(el);
            filterType.classList.add("hide-filters");
            filterType.classList.remove("shadow-2", "h5");
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
    });
  })();
}

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

function selectAll(query) {
  return Array.prototype.slice.call(document.querySelectorAll(query));
}

function toggleArrows(type) {
  toggleClasses(select(".select-" + type + "-filters > h5 > .fa-up"), ["filter-arrow-hide"]);
  toggleClasses(select(".select-" + type + "-filters > h5 > .fa-down"), ["filter-arrow-hide"]);
}

// Site is fully functional without javascript
// so if these methods do not exist (Internet Explorer 8 & unsupported browsers)
// fall back to non-javascript
// https://www.gov.uk/service-manual/technology/designing-for-different-browsers-and-devices
function isNotIE8() {
  return Element.prototype.addEventListener && Array.prototype.forEach;
}
