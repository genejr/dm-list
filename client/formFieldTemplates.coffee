UI.registerHelper 'formField', () ->
  # if this.inputType is 'hidden'
  #   console.log 'hidden',this

  template =
    switch this.inputType
      when 'autocomplete' then 'autocompleteFieldTemplate'
      when 'text' then 'textFieldTemplate'
      when 'textarea' then 'textAreaFieldTemplate'
      when 'password' then 'passwordFieldTemplate'
      when 'hidden' then 'hiddenFieldTemplate'
      when 'static' then 'staticFieldTemplate'
      when 'staticDate' then 'staticFieldTemplate'
      when 'select' then 'selectFieldTemplate'
      when 'selectState' then 'selectFieldTemplate'
      when 'selectCountry' then 'selectFieldTemplate'
      when 'address' then 'addressFieldsTemplate'
      when 'phone' then 'phoneFieldsTemplate'
      when 'checkbox' then 'checkboxFieldTemplate'
      when 'tabs' then 'tabsFieldTemplate'
      when 'dateTime' then 'dateTimeFieldTemplate'
      when 'hrule' then 'hrFieldTemplate'
      when 'richtext' then 'xeditableFieldTemplate'
      else 'staticFieldTemplate'

  if not this.size? and not this.inputType is 'hidden'
      throw new Meteor.Error 'size required', "#{this.inputType} requires a size between 1-12"

  if this.inputType is 'checkbox'
      if this.value is 'checked'
        this.checked = 'checked'
      else
        this.checked = ''

  if this.inputType is 'staticDate'
    this.value = moment.unix(this.value).format("DD MMM YYYY HH:mm")

  if this.inputType is 'dateTime'
    _events = {}
    templateEvent = "click .btn-#{this.name}-clear"
    if not DMUtils.find(Template.dateTimeFieldTemplate._events, 'selector', ".btn-#{this.name}-clear")
      _events[templateEvent] = (event,template) ->
        element = template.find("input")
        element.value = ""
        return false
    Template.dateTimeFieldTemplate.events(_events)

  if this.inputType is 'selectState'
    states = States.find({}).fetch()
    _states = []
    _item =
      option_label: this.label
    _states.push _item

    for state in states
      _item =
        option_label: state.name
        option_value: state.iso
      if this.value is state.iso
        _item.checked = 'selected'
      _states.push _item
    this.values = _states

  if this.inputType is 'selectCountry'
    countries = Countries.find({}).fetch()
    _countries = []
    _item =
      option_label: this.label
    _countries.push _item

    for countrie in countries
      _item =
        option_label: countrie.name
        option_value: countrie.iso
      if this.value is countrie.iso
        _item.checked = 'selected'
      _countries.push _item
    this.values = _countries

  if this.inputType is 'richtext'
    if not this.height?
      this.height = '300px'
      console.warn "richtext height attribute not set. Using default of 300px."

  # select input type
  if this.inputType is 'select'
    new_items = []
    _item =
      option_label: this.label

    new_items.push _item
    if this.static_values
      options = this.static_values
    if this.options
      options = this.options

    if options.fetch?
      options = options.fetch()

    # First run through the values are just text items in the array.
    for item in options
      if Object.isNumber(item)
        option_label = item
      else if Object.isString(item)
        option_label = item

      if item._id?
        option_value = item._id
      else
        option_value = item

      if this.display_attribute
        option_label = item[this.display_attribute].titleize()

      _item =
        option_label: option_label
        option_value: option_value

      if item._id? and this.value is item._id
        _item.checked = 'selected'

      else if this.value is item.toString()
          _item.checked = 'selected'

      new_items.push _item
    this.values = new_items

  if typeof this.label is 'undefined' and this.inputType isnt 'hidden'
    this.label = this.name?.titleize()

  if this.renderIfEmpty is true and not this.value?
    this.value = ''
    return Template[template]
  else
    return Template[template]

Template.autocompleteFieldTemplate.rendered = ->
  Meteor.typeahead.inject();

Template.xeditableFieldTemplate.rendered = ->
  xeditable = $("##{this.data.name}-xeditable")
  xeditable.wysihtml5()
  # xeditable.wysihtml5({
  #   # success: (response, newValue) ->
  #   #   console.log "New Value: ", newValue
  #     # <do something with newValue - usually a collection.update call>
  #   "font-styles": true   #//Font styling, e.g. h1, h2, etc. Default true
  #   "emphasis": true      #//Italics, bold, etc. Default true
  #   "lists": true         #//(Un)ordered lists, e.g. Bullets, Numbers. Default true
  #   "html": false         #//Button which allows you to edit the generated HTML. Default false
  #   "link": true          #//Button to insert a link. Default true
  #   "image": true         #//Button to insert an image. Default true,
  #   "color": false        #//Button to change color of font
  #   placement: "auto top"
  # });

Template.dateTimeFieldTemplate.rendered = ->
  datepicker = $("##{this.data.name}-picker")

  datepicker.datetimepicker(this.data.options);

  if this.data.value isnt undefined
    datepicker.data('DateTimePicker').setDate(moment(this.data.value));

  return


UI.registerHelper 'printField', () ->
  template =
    switch this.inputType
      when 'hidden' then 'printFieldHiddenTemplate'
      when 'textarea' then 'printFieldTextareaTemplate'
      else 'printFieldTemplate'

  if this.inputType is 'textarea'
    this.value = new Spacebars.SafeString(this.value)

  if this.inputType is 'checkbox'
      if this.value is 'checked'
        this.checked = 'checked'

  if this.inputType is 'staticDate'
    this.value = moment.unix(this.value).format("DD MMM YYYY HH:mm")

  # if this.value is null
  #   this.value = '&nbsp;'


  if typeof this.label is 'undefined' and this.inputType isnt 'hidden'
    this.label = this.name?.titleize()

  return Template[template]
