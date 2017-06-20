(function () {
  selectAll('.resource-link').forEach(function (el) {
    el.addEventListener('click', function (e) {
      var resource_id = get_resource_id(e.target);
      if (document.cookie.indexOf('ldmw_visited_resources') === -1) {
        document.cookie = 'ldmw_visited_resources=' + resource_id;
      } else {
        var visited_resources = get_visited_resources();
        if (visited_resources.indexOf(resource_id) === -1) {
          document.cookie = 'ldmw_visited_resources=' + visited_resources.join() + ',' + resource_id;
        }
      }
    });
  });

  function get_resource_id(node) {
    if(node.id.indexOf('resource_') > -1) {
      return node.id.split('_')[1];
    }

    if(!node.parentNode) {
      console.log('Could not find resource_id');
      return;
    }

    return get_resource_id(node.parentNode);
  }

  function get_visited_resources () {
    return document.cookie.match(/ldmw_visited_resources=([^;]+);/)[1].split(',');
  }

  function populate_visited_resources () {
    get_visited_resources().forEach(function (resource_id) {
      select('#visited_resources').innerHTML += select('.resource_title', select('#resource_' + resource_id)).innerHTML
    });
  }

  document.addEventListener('DOMContentLoaded', function () {
    populate_visited_resources();
  });
})();
