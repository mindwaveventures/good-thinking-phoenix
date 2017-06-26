(function () {
  var our_cookie = 'ldmw_accepted_cookie_policy=1';
  function show_cookie_bar () {
    if (document.cookie.indexOf(our_cookie) > -1) {
      console.log('Cookie policy accepted');
      if (select('#cookie_accept_bar').className.indexOf('dn') === -1) {
        toggleClasses(select('#cookie_accept_bar'), ['dn']);
      }
      return;
    }

    toggleClasses(select('#cookie_accept_bar'), ['dn']);
  }

  function accept_cookie_listener() {
    select('#cookie_accept_bar > button')
      .addEventListener('click', function () {
        var d = new Date();
        var one_day = 24 * 60 * 60 * 1000;
        d.setTime(d.getTime() + one_day);
        var expires = ';expires=' + d.toUTCString();
        document.cookie = our_cookie + expires;
        show_cookie_bar();
      });
  }

  document.addEventListener('DOMContentLoaded', function () {
    show_cookie_bar();
    accept_cookie_listener();
  });
})();
