Package.describe({
  summary: "A pattern to display application notices to the user"
});

Package.onUse(function (api, where) {
  api.use(['minimongo', 'mongo-livedata', 'templating'], 'client');

  api.addFiles(['notices.js', 'notices_list.html', 'notices_list.js'], 'client');
});

Package.on_test(function(api) {
  api.use('notices', 'client');
  api.use(['tinytest', 'test-helpers'], 'client');  

  api.addFiles('notices_tests.js', 'client');
});