
Template.lists.helpers
	lists: () ->
		data = this
		title = data.title

		# Template._listForm.helpers(data.form.helpers)

		Template._listRow.events(data.row.events)
		if data.row?.helpers?
			Template._listRow.helpers(data.row.helpers)

		Template.lists.events(data.list.events)



		items = []
		for item in data.items()
			data = Object.reject(data, 'items')
			item.context = data
			items.add item

		if items.length > 0
			return items

Template._listRow.helpers
	disabled: () ->
		this.status

	selected: () ->
		context = this.context
		single = context.single
		user = Meteor.user()
		
		return getUserSelectedItem(user, single, this._id) and 'alert-info'

Template._listRow.events
	"click .close-form": () ->
		$('.form-row').addClass('hidden')
		return false

# Helper for the column headers.  data should have the field
# names in listFields.
Handlebars.registerHelper 'listColumnHeaders', (data) ->
	listFields = data.listFields
	columnHeaders = 
		for field in listFields
			if field.label?
				field.label.titleize()
			else
				field.name.titleize()

	returnData = 
		columnHeaders: columnHeaders

	return new Handlebars.SafeString Template._listColumnHeaders(returnData)


Handlebars.registerHelper 'listRow', () ->
	data = this
	context = data.context
	
	data.row_css_class = "#{context.title.toLowerCase()}-row"
	data.listFields = context.listFields
	data.rowControls = context.rowControls
	data.form = context.form
	return new Handlebars.SafeString Template._listRow(data)

Handlebars.registerHelper 'listRowColumn', (data, context) ->
	if typeof data.callback isnt 'undefined' and typeof data.callback is 'function'
		value = data.callback(context)
	else
		value = prop(context, data.name)

	if typeof value is 'undefined'
		value = ''

	if data.template?
		return new Handlebars.SafeString Template[data.template](value)
	else
		return new Handlebars.SafeString Template._listRowColumn(value)
	
Handlebars.registerHelper 'ListAddEditModal', (data, context) ->
	return new Handlebars.SafeString Template._listAddEditModal(data)

Handlebars.registerHelper 'ListForm', (data, context) ->
	fields = []
	providedFields = data.form.helpers.fields
	if not Array.isArray(providedFields)
		for key in Object.keys(providedFields)
			options = providedFields[key]
			options.name = key
			fields.add options
		data.form.helpers.fields = fields
	return new Handlebars.SafeString Template._listForm(this)

Handlebars.registerHelper 'Count', (array) ->
	return array.length + 1