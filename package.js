Package.describe({
	summary: "A list and associated forms for managing list records"
});

Package.on_use(function (api, where) {
	api.use(['templating', 'coffeescript', 'less', 'Mesosphere', 'paginate', 'bootstrap','handlebars'], ['client','server']);
	api.add_files([
		// 'client/images/volume-down.png',
		'client/list.html',
		'client/list.coffee',
		'client/list.less'
		],'client');
});