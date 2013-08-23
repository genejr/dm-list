Package.describe({
	summary: "A list and associated forms for managing list records"
});

Package.on_use(function (api, where) {
	api.use(['templating', 'coffeescript', 'less', 'Mesosphere', 'paginate', 'bootstrap','handlebars', 'bootboxjs'], ['client','server']);
	api.add_files([
		'client/userDataPopover.html',
		'client/userDataPopover.coffee',
		'client/controlButton.html',
		'client/controlButton.coffee',
		'client/phoneTemplate.html',
		'client/addressTemplate.html',
		'client/formFieldTemplates.html',
		'client/formFieldTemplates.coffee',
		'client/list.html',
		'client/list.coffee',
		'client/list.less'
		],'client');
});