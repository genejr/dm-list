UI.registerHelper "control_button", ->
	if typeof this.link isnt 'string'
		this.link = null

	if typeof this.css isnt 'string' and this.css is ''
		this.css = null

	return Template._control_button
#----------------------------------------------------------------------