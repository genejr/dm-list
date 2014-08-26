Package.describe({
  summary: "A list and associated forms for managing list records",
  version: "1.1.0",
  git: "https://github.com/digilord/dm-list"
});

Package.on_use(function (api) {
	api.versionsFrom('METEOR@0.9.0')
	api.use('templating')
	api.use('ui')
	api.use('coffeescript')
	api.use('less')
	api.use('copleykj:mesosphere')
	api.use('mizzao:bootstrap-3')
	api.use('mizzao:bootboxjs')
	api.use('mrt:moment')
	api.use('tsega:bootstrap3-datetimepicker')
	
	api.use('bootstrap3-datetimepicker')
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
