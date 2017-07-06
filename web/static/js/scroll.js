function changeBackgroundColor () {
  document.getElementById("beta-banner").style.backgroundColor="white";
}
if (isNotIE8()) {
  document.getElementById("beta-banner").style.backgroundColor="transparent"
  window.onscroll = function(){changeBackgroundColor()};
};
