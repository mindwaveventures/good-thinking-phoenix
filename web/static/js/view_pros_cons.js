function handleViewProsCons (e, el) {
  toggleClasses(select('#pros_cons' + getResourceId(el)), ['dn']);
  changeInnerHtml(el);
}

function changeInnerHtml (el) {
  if (el.innerHTML === "View pros and cons") {
    el.innerHTML = "Hide pros and cons";
  } else {
    el.innerHTML = "View pros and cons";
  }
}

selectAll('.view_pcs').forEach(function (el) {
  el.addEventListener('click', function (e) {
    handleViewProsCons(e, el);
  });
});
