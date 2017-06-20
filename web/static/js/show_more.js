selectAll('.resource').forEach(function (el, i) {
  if(el.id.substring(0, 9) === 'resource_' && i > 2) {
    toggleClasses(el, ['dn']);
  }
});
function handle_see_more(e) {
  selectAll('.resource').forEach(function (el, i) {
    if(el.id.substring(0, 9) === 'resource_' && el.className.indexOf('dn') > -1) {
      toggleClasses(el, ['dn']);
    }
  });
  toggleClasses(select('#see_more'), ['dn-important']);
}
if (selectAll('.resource').length > 3) {
  toggleClasses(select('#see_more'), ['dn-important']);
  select('#see_more').addEventListener('click', handle_see_more);
}
