function handle_view_pros_cons(e, el) {
  toggleClasses(select('#pros_cons' + getResourceId(el)), ['dn']);
};

selectAll('.view_pcs').forEach(function (el) {
  el.addEventListener('click', function (e) {
    handle_view_pros_cons(e, el);
  });
});
