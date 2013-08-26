Template._user_data_popover.rendered = () ->
	data = this.data
	
	if data?.emails?
		data.email = data.emails[0].address

	content = Template._user_data_popover_content(data)
	$("##{data?._id}").popover({ title: 'Contact this Person', placement: 'bottom', content: content, html: true });