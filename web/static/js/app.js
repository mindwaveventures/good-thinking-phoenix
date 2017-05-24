// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

document.querySelector(".sidebar-overlay").addEventListener('click', function() {
  document.querySelector("#filter_filter").checked = false;
  document.querySelector("body").classList.remove("stop-scrolling");
});

document.querySelector("#filter_filter").addEventListener('click', function() {
  document.querySelector("body").classList.toggle("stop-scrolling");
});

document.querySelector(".sidebar-buttons").classList.add("absolute", "bottom-2");

Array.prototype.forEach.call(document.querySelectorAll(".filter-arrow"), function(el) {
  el.classList.remove("filter-arrow-hide");
});

["category", "audience", "content"].forEach(function(el) {
  document.querySelector("." + el + "-filters").classList.add("hide-filters", "br1", "w-80", "absolute", "bg-white", "z-1", "overflow-scroll");
  document.querySelector(".select-" + el + "-filters").classList.add("select-filters");
  document.querySelector(".select-" + el + "-filters").addEventListener("click", function() {
    document.querySelector("." + el + "-filters").classList.toggle("hide-filters");
    document.querySelector("." + el + "-filters").classList.toggle("shadow-2");
    document.querySelector("." + el + "-filters").classList.toggle("h5");
    document.querySelector(".sidebar").addEventListener("click", function hideAgain(e){
      if (e.path.indexOf(document.querySelector(".select-" + el + "-filters")) == -1 && e.path.indexOf(document.querySelector("." + el + "-filters")) == -1){
        document.querySelector("." + el + "-filters").classList.add("hide-filters");
        document.querySelector("." + el + "-filters").classList.remove("shadow-2");
        document.querySelector("." + el + "-filters").classList.remove("h5");
        document.querySelector(".sidebar").removeEventListener("click", hideAgain);
      }
    });
  });
});
