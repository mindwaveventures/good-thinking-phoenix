selectAll('#results > div > div').forEach(function (el, i) {
  if(el.id.substring(0, 9) === 'resource_' && i > 3) {
    toggleClasses(el, ['dn']);
  }
});
function handle_see_more(e) {
  selectAll('#results > div > div').forEach(function (el, i) {
    if(el.id.substring(0, 9) === 'resource_' && el.className.indexOf('dn') > -1) {
      toggleClasses(el, ['dn']);
    }
  });
  toggleClasses(select('#see_more'), ['dn-important']);
}
if (selectAll('#results > div > div').length > 3) {
  toggleClasses(select('#see_more'), ['dn-important']);
  select('#see_more').addEventListener('click', handle_see_more);
}

