# Template._lists.rendered = () ->
#   data = this.data
#   editing = Session.get("edit-#{data.single}")
#   if editing?
#     element = $("##{editing}")
#     element.removeClass('hidden')


Template._lists.helpers
  lists: () ->
    # console.log 'Template._lists.helpers', this
    data = Object.clone(this)

    title = data.title
    if not data.single?
      console.warn 'data.single is empty or undefined', data
    if typeof data.test isnt 'undefined'
      console.log data.test

    if data?.row?.events?
      Template._listRow.events(data?.row?.events)

    if data.row?.helpers?
      Template._listRow.helpers(data.row.helpers)


    # Define some events that will be available even
    # if the user doesn't define them.  To override
    # these events simply define your own in the passed
    # data as list.events.
    listEvents = {}
    _listRowEvents = {}
    templateEvent = "click .select-#{data.single.dasherize()}"
    if not DMUtils.find(Template._listRow._events, 'selector', ".select-#{data.single.dasherize()}")
      _listRowEvents[templateEvent] = (event,template) ->
        data = template.data
        single = data.context.single
        sessionVar = "selected-#{single}"
        if Session.get(sessionVar) is data._id
          Session.set(sessionVar, null)
        else
          Session.set(sessionVar, data._id)

        return false

    templateEvent = "click .enable-#{data.single.dasherize()}"
    if not DMUtils.find(Template._listRow._events, 'selector', ".enable-#{data.single.dasherize()}")
      _listRowEvents[templateEvent] = (event,template) ->
        data = template.data
        single = data.context.single
        Klass = data.context.klass
        bootbox.itemId = data._id
        confirmation = """
        Are you sure you want to re-enable this #{single}?
        """
        bootbox.confirm confirmation, (confirmed) ->
          if confirmed
            Klass.update bootbox.itemId, {$set: {status: ''}}
        return false

    templateEvent = "click .disable-#{data.single.dasherize()}"
    if not DMUtils.find(Template._listRow._events, 'selector', ".disable-#{data.single.dasherize()}")
      _listRowEvents[templateEvent] = (event,template) ->
        data = template.data
        single = data.context.single
        Klass = data.context.klass
        bootbox.itemId = data._id
        if typeof data.context.disableMessageTemplate isnt 'undefined'
          confirmation = data.context.disableMessageTemplate
        else
          confirmation = """
          Are you sure you want to disable this #{single}?
          <br>
          <br>
          <div class='alert alert-error'>
            <h4>Severe Warning</h4>
            No users will be able to use this #{single}.  This could lead to a service interruption.
          </div>
          """

        bootbox.confirm confirmation, (confirmed) ->
          if confirmed
            Klass.update bootbox.itemId, {$set: {status: 'disabled'}}
        return false

    templateEvent = "click .edit-#{data.single.dasherize()}"
    if not DMUtils.find(Template._listRow._events, 'selector', ".edit-#{data.single.dasherize()}")
      _listRowEvents[templateEvent] = (event,template) ->
        data = template.data
        # console.log data
        if data.context.formType is 'link'
          link = "/#{data.context.single.dasherize()}/#{data._id}/edit"
          Router.go(link)
          return

        single = data.context.single
        Session.set("editDocument", data._id)
        element = $("##{data._id}")
        if element.hasClass('hidden')
          $('.form-row').addClass('hidden')
          element.removeClass('hidden')
        else
          element.addClass('hidden')
          Session.set("editDocument", null)
        return false

    # templateEvent = "click .save-#{data.single}"
    # if not DMUtils.find(Template._listRow._events, 'selector', ".save-#{data.single}")
    #   _listRowEvents[templateEvent] = (event,template) ->
    #     event.preventDefault()
    #     data = template.data
    #     # Find this templates 'fields'
    #     fields = template.findAll('input, select, textarea')

    #     # Setup a new object to store all of the data
    #     field_objects = {};

    #     # Loop over the fields with _ placing the fields as attributes
    #     # on the field_objects object.
    #     for field in fields
    #       value = field.value;
    #       name = field.name;
    #       if name? and name isnt ""
    #         field_objects[name] = value;

    #     Meteor.call data.context.mesoObject.method, field_objects

    #     return false

    templateEvent = "click .close-form-#{data.single.dasherize()}"
    if not DMUtils.find(Template._listRow._events, 'selector', ".close-form-#{data.single.dasherize()}")
      _listRowEvents[templateEvent] = (event,template) ->
        data = template.data
        single = data.context.single
        element = $("##{data._id}")
        element.addClass('hidden')
        Session.set("editDocument", null)
        return false

    # Add in or override user defined events.
    if data.list?.events?
      _.extend(data.list.events, listEvents)
      Template._lists.events(data.list.events)
    else
      Template._lists.events(listEvents)

    if data?.row?.events?
      _.extend(data.row.events, _listRowEvents)
      # console.log data.row.events
      Template._listRow.events(data.row.events)
    else
      # console.log _listRowEvents, Template._listRow._events
      Template._listRow.events(_listRowEvents)

    # Build up an array of the items to be in the list
    # adding in the context data
    items = []
    # if data.parent_id
    #   data.subscribeCallback(data.parent_id)
    # else
    #   data.subscribeCallback()

    # console.log 'data.parent_id', data.parent_id
    # console.log 'data', data
    if data.parent_id?
      _items = data.list.items(data.parent_id)
    else
      _items = data.list.items()

    for item in _items
      item.context = data
      items.push item

    if items.length > 0
      return items

Template.listNav.helpers
  nav: () ->
    # console.log 'listNav:nav', this
    data = Object.clone(this)
    single = data.single
    plural = data.plural
    singleTitle = single.titleize()
    pluralTitle = plural.titleize()

    if data.nav?.events?
      Template.listNav.events(data.nav.events)
    else
      Template.listNav.events(navEvents)

    # Define some events that will be available even
    # if the user doesn't define them.  To override
    # these events simply define your own in the passed
    # data as nav.events.
    navEvents = {}

    templateEvent = "click .add-#{data.single.dasherize()}"
    if not DMUtils.find(Template.listNav._events, 'selector', ".add-#{data.single.dasherize()}")
      navEvents[templateEvent] = (event, template) ->
        context = template.data
        single = context.single
        klass = context.klass
        console.log "You have not defined a custom add handler for #{data.title}.  Using the default."
        if Object.isFunction(context.nav.newItemCallback)
          _id = context.nav.newItemCallback(context.parent_id)
        else
          console.warn 'You have not defined a newItemCallback or new route for this package.'
          return false

        # Show the edit form after a 100ms delay after the item is inserted.
        showForm = () ->
          $("##{_id}").removeClass('hidden')
          Session.set("editDocument", _id)

        setTimeout showForm, 100, _id

        return false
    # ---------------------------------------------------------------------------------------

    templateEvent = "click .purge-disabled-#{data.plural.dasherize()}"
    if not DMUtils.find(Template.listNav._events, 'selector', ".purge-disabled-#{data.plural.dasherize()}")
      navEvents[templateEvent] = (event, template) ->
        context = template.data
        plural = context.plural
        console.log "You have not defined a custom purge handler for #{data.title}.  Using the default."
        confirm_dialog = """
        Are you sure you want to purge the diabled #{plural}?
        <br><br>
        <div class='alert alert-error'>
          <h4>Severe Warning</h4>
          All purged #{plural} cannot be recovered.  This will be your ONLY warning.
        </div>
        """

        bootbox.confirm confirm_dialog, (confirmed) ->
          if confirmed
            Meteor.call "purge#{context.title}",
            (error, result) ->
              if error
                Meteor.Errors.throw error
              if result
                Meteor.Notices.throw('Your disabled records have been purged.', 'success')
        return false
    # ---------------------------------------------------------------------------------------

    templateEvent = "click .reset"
    if not DMUtils.find(Template.listNav._events, 'selector', ".reset")
      navEvents[templateEvent] = (event, template) ->
        context = template.data
        single = context.single
        $(".#{single}-search").addClass('hide')
        $(".#{single}-search-query").attr('value','')
        Session.set("#{single}Find",{})
        return false

    # ---------------------------------------------------------------------------------------
    # Search
    # At the moment the query for search uses name as the key.  Need to revist this
    # to make it so that the package user can set what the default
    templateEvent = "keyup .#{data.single.dasherize()}-search-query"
    if not DMUtils.find(Template.listNav._events, 'selector', ".#{data.single.dasherize()}-search-query")
      navEvents[templateEvent] = (event, template) ->
        context = template.data
        single = context.single
        value = event.target.value
        $(".#{data.single.dasherize()}-search").removeClass("hide")
        if value?
          if value.has("=")
            key = value.split("=")[0]
            search_string = value.split("=")[1]
            search = {}
            search[key] =
              $regex: ".*#{search_string}.*"
              $options: "i"
            Session.set("#{data.single.dasherize()}Find", search)
          else if value.has(" ")
            search_terms = value.split " "
            regex_array =
              for term in search_terms
                 ".*#{term}.*"
            regex = regex_array.join "|"
            Session.set("#{data.single.dasherize()}Find", {name: {$regex: regex, $options: "i"}})
          else
            regex = ".*#{value}.*"
            Session.set("#{data.single.dasherize()}Find", {name: {$regex: regex, $options: "i"}})
        else
          Session.set("#{data.single.dasherize()}Find", {})
          $(".#{data.single.dasherize()}-search").addClass("hide")
          $(".#{data.single.dasherize()}-search-query").attr("value","")
        return false

    # Setup the add and purge buttons if the user
    # didn't pass in any.
    if not data.nav.addButton? and data.nav.addButton isnt false
      data.nav.addButton =
        title: "#{singleTitle}"
        label: "#{singleTitle}"
        click: "add-#{single.dasherize()}"
        style: "success"
        icon: "plus"
        css: 'navbar-btn'

    if not data.nav.purgeButton? and data.nav.purgeButton isnt false
      data.nav.purgeButton =
        title: "#{pluralTitle}"
        label: "#{pluralTitle}"
        click: "purge-disabled-#{plural.dasherize()}"
        style: "danger"
        icon: "remove"
        css: 'navbar-btn'

    Template.listNav.events(navEvents)
    return data.nav



Template._listRow.helpers
  disabled: () ->
    this.status

  selected: () ->
    context = this.context
    single = context.single
    if Session.get("selected-#{single}") is this._id
      return 'alert-info'

  editDocument: ->
    _editId =  Session.get('editDocument')
    # console.log 'EDIT!', _editId
    if _editId is this._id
      return true
    else
      return false


UI.registerHelper 'ListNav', () ->
  # console.log "UI.registerHelper 'ListNav'", this
  return Template.listNav

UI.registerHelper 'lists', () ->
  # console.log "UI.registerHelper 'lists'", this
  this.lists = this.items
  return Template._lists

# Helper for the column headers.  data should have the field
# names in listFields.
UI.registerHelper 'listColumnHeaders', () ->
  # console.log "UI.registerHelper 'listColumnHeaders'", this
  listFields = this.list.listFields
  if Array.isArray(listFields) and listFields.length > 0
    columnHeaders =
      for field in listFields
        if not field.label?
          field.name.titleize()
        else
          field.label

    this.columnHeaders = columnHeaders

  return Template._listColumnHeaders


UI.registerHelper 'listRow', () ->
  data = Object.clone(this)
  # console.log "UI.registerHelper 'listRow'", data
  context = data.context
  rowControls = context.list.rowControls

  data.row_css_class = "#{data._id}-row"
  data.listFields = context.list.listFields

  # console.log context.rowControls
  data.rowControls = {}
  for control in Object.keys(rowControls)
    array = []
    _control = rowControls[control]
    for item in Object.keys(_control)
      _item = _control[item]
      controlData = Object.reject(data, 'context')
      _item.data = controlData
      array.push _item
    data.rowControls[control] = array


  data.form = context.form
  data.inlineForm =
    switch context.formType
      when 'inline' then true
      when 'full' then false
      when 'link' then false
      else true

  this.row = data
  this.data = data

  # console.log this
  return Template._listRow

UI.registerHelper 'listRowColumn', () ->
  # console.log 'listRowColumn', this
  if this.field.transform and Object.isFunction(this.field.transform)
    transform = this.field.transform
    this.value = transform(this.data[this.field.name])
  else
    this.value = this.data[this.field.name]

  return Template._listRowColumn

UI.registerHelper 'ListAddEditModal', () ->
  return Template._listAddEditModal

UI.registerHelper 'ListForm', () ->
  console.log 'ListForm Start', this

  listFormEvents =
    'click .close-form': (event, template) ->
      event.preventDefault()
      data = template.data.data
      element = $("##{data._id}")
      if element.hasClass('hidden')
          $('.form-row').addClass('hidden')
          element.removeClass('hidden')
        else
          element.addClass('hidden')
        return false

    'click .show-created-updated': (event, template) ->
      event.preventDefault()
      console.log 'Clicked show-created-updated'
      show = Session.get('showDateTime')
      showValue =
        switch show
          when true then false
          when false then true
          else true

      Session.set('showDateTime', showValue)
      return false

  data = this.data
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
  if form.events?
    console.log 'Working on _listForm.events'

    events = Object.merge(form.events, listFormEvents)
    console.log events
    Template._listForm.events = events
  else
    Template._listForm.events = listFormEvents

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

  this.formButtons = false

  if form.buttons?
    _formButtons = []
    if not Array.isArray(form.buttons)
      for key of form.buttons
        options = form.buttons[key]
        _formButtons.push options

      this.formButtons = _formButtons

  console.log 'ListForm End', this
  return Template._listForm






Template._listForm.helpers
  showDateTime: () ->
    return Session.get('showDateTime')

UI.registerHelper 'Count', (array) ->
  return array.length + 1
