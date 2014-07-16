UI.registerHelper 'PrintView', () ->
  # console.log 'PrintView Start', this

  data = this
  if data.context?.list?.form?
    form = data.context?.list?.form
    # console.log 'First else for ListForm.', form
  else if data.context?.form
    form = data.context?.form
    # console.log 'Second else for ListForm.', form
  else
    form = this.form
    # console.log 'Last else for ListForm.', form

  fields = []

  if form?.css?
    this.css = form.css
  else
    this.css = 'lower-tab'

  if form?.fields?
    providedFields = form.fields
  else
    providedFields = []

  if data.formType is 'inline'
    this.isListForm = true
  else
    this.isListForm = false

  if form?.name?
    this.form_name = form.name

  if not Array.isArray(providedFields)
    for key in Object.keys(providedFields)
      options = providedFields[key]
      # console.log options
      options.name = key
      if options.transform and Object.isFunction(options.transform)
        transform = options.transform
        options.value = transform(data[key])
      else
        options.value = data[key]

      fields.push options
    this.fields = fields
#

  # console.log 'ListForm End', this
  return Template._printView
