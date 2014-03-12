Handlebars.registerHelper "control_button", (click='', style, icon, title='',  css='', link='' ) ->
  if typeof link isnt 'string'
    link = null

  if typeof css is 'string' and css isnt ''
    css = css
  else
    css = null

  obj =
    click: click if typeof click is 'string'
    style: style if typeof style is 'string'
    icon: icon if typeof icon is 'string'
    title: title if typeof title is 'string'
    css: css
    link: link

  return Template._control_button(obj)
#----------------------------------------------------------------------