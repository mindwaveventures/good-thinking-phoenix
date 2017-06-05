selectAll('#results > div > div').forEach(function (el, i) {
  if(el.id.substring(0, 9) === 'resource_' && i > 5) {
    toggleClasses(el, ['dn']);
  }
});
var see_more_div = document.createElement('div');
var see_more_button = document.createElement('button');
see_more_button.innerHTML = 'See More';
see_more_div.id = 'see_more';
see_more_button.classList = 'pointer'
see_more_div.appendChild(see_more_button);
select('#results').appendChild(see_more_div);
function handle_see_more(e) {
  selectAll('#results > div > div').forEach(function (el, i) {
    if(el.id.substring(0, 9) === 'resource_') {
      toggleClasses(el, ['dn']);
    }
  })
  toggleClasses(select('#see_more'), ['dn']);
}
see_more.addEventListener('click', handle_see_more);

