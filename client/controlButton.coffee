UI.registerHelper "control_button", () ->

  template =
    switch this.buttonType
      when 'link' then 'controlButtonLinkTemplate'
      when 'input' then 'controlButtonInputTemplate'
      else '_control_button'

  # data = Object.clone(this)
  # console.log data
  # if typeof this.link isnt 'string'
  #   this.link = null

  # if typeof this.css isnt 'string' and this.css is ''
  #   this.css = null

  return Template[template]
#----------------------------------------------------------------------
