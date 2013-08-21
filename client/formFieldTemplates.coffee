Handlebars.registerHelper 'formField', (field, context) ->
	template = 
		switch field.inputType
			when 'text' then 'textFieldTemplate'
			when 'hidden' then 'hiddenFieldTemplate'
			when 'static' then 'staticFieldTemplate'
			when 'select' then 'selectFieldTemplate'
			when 'address' then 'addressFieldsTemplate'
			when 'phone' then 'phoneFieldsTemplate'
			when 'checkbox' then 'checkboxFieldTemplate'
			when 'tabs' then 'tabsFieldTemplate'
			else 'textFieldTemplate'
	if typeof field.value isnt 'function'
		field.value = () ->

	if typeof field.label is 'undefined' and field.inputType isnt 'hidden'
		field.label = field.name.titleize()

	field.data = context
	if field.renderIfEmpty or typeof field.value(this) isnt 'undefined'
		return new Handlebars.SafeString Template[template](field)

