uuid = ->
  'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = if c is 'x' then r else (r & 0x3|0x8)
    v.toString(16)
  )

Handlebars.registerHelper "control_button", (click='', style, icon, title='',  css='' ) ->


	if typeof css is 'string' and css != ''
		css = css
	else
		css = null

	obj =
		click: click if typeof click is 'string'
		style: style if typeof style is 'string'
		icon: icon if typeof icon is 'string'
		title: title if typeof title is 'string'
		css: css

	return Template._control_button(obj)
#----------------------------------------------------------------------