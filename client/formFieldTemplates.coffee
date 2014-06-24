Handlebars.registerHelper 'formField', () ->
	template = 
		switch this.inputType
			when 'text' then 'textFieldTemplate'
			when 'textarea' then 'textAreaFieldTemplate'
			when 'password' then 'passwordFieldTemplate'
			when 'hidden' then 'hiddenFieldTemplate'
			when 'static' then 'staticFieldTemplate'
			when 'select' then 'selectFieldTemplate'
			when 'address' then 'addressFieldsTemplate'
			when 'phone' then 'phoneFieldsTemplate'
			when 'checkbox' then 'checkboxFieldTemplate'
			when 'tabs' then 'tabsFieldTemplate'
			else 'textFieldTemplate'

	if typeof this.label is 'undefined' and this.inputType isnt 'hidden'
		this.label = this.name?.titleize()

	if this.renderIfEmpty or this.value isnt null
		return Template[template]

