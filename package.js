Package.describe({
  summary: "A list and associated forms for managing list records"
});

Package.on_use(function (api, where) {
	api.use(['templating',
	'coffeescript',
	'less',
	'Mesosphere',
	'bootstrap-3',
	'ui',
	'bootboxjs',
	'moment',
	'ui',
	'bootstrap3-datetimepicker'
	], ['client','server']);
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
		'client/list.less',
    'client/print.html',
    'client/print.coffee',
    'client/print.less'
		],'client');
	api.add_files(['lib/dm-utils.coffee', 'lib/callbacks.coffee'], ['client','server'])
});
