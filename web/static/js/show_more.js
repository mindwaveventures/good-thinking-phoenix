selectAll('#results > div > div').forEach(function (el, i) {
  if(el.id.substring(0, 9) === 'resource_' && i > 3) {
    toggleClasses(el, ['dn']);
  }
});
function handle_see_more(e) {
  selectAll('#results > div > div').forEach(function (el, i) {
    if(el.id.substring(0, 9) === 'resource_') {
      toggleClasses(el, ['dn']);
    }
  });
  toggleClasses(select('#see_more'), ['dn-important']);
}
toggleClasses(select('#see_more'), ['dn-important']);
see_more.addEventListener('click', handle_see_more);

