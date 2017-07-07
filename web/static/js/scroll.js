function changeBackgroundColor () {
  banner.style.backgroundColor="white";
  addClasses(banner, ["shadow-2"])
}

if (isNotIE8()) {
  var banner = select("#beta-banner")
  banner.style.backgroundColor="transparent";
  removeClasses(banner, ["shadow-2"]);
  window.onscroll = function(){changeBackgroundColor(banner)};
};
