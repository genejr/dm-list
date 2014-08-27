Package.describe({
  summary: "A list and associated forms for managing list records",
  version: "1.1.0",
  git: "https://github.com/digilord/dm-list",
  name: "digilord:list"
});

Package.on_use(function (api) {
	api.versionsFrom('METEOR@0.9.0')
	api.use('templating')
	api.use('ui')
	api.use('coffeescript')
	api.use('less')
	api.use('copleykj:mesosphere@0.1.10')
	api.use('mizzao:bootstrap-3@3.2.0')
	api.use('mizzao:bootboxjs@4.3.0')
	api.use('mrt:moment@2.8.1')
	api.use('tsega:bootstrap3-datetimepicker@0.2.0')
	
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
