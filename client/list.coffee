Template.lists.rendered = () ->
  data = this.data
  editing = Session.get("edit-#{data.single}")
  if editing?
    element = $("##{editing}")
    element.removeClass('hidden')


Template.lists.helpers
  lists: () ->
    data = this
    title = data.title
    if typeof data.single is 'undefined'
      console.log data
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
    templateEvent = "click .select-#{data.single}"
    if not DMUtils.find(Template._listRow._events, 'selector', ".select-#{data.single}")
      _listRowEvents[templateEvent] = (event,template) ->
        data = template.data
        single = data.context.single
        sessionVar = "selected-#{single}"
        if Session.get(sessionVar) is data._id
          Session.set(sessionVar, null)
        else
          Session.set(sessionVar, data._id)

        return false

    templateEvent = "click .enable-#{data.single}"
    if not DMUtils.find(Template._listRow._events, 'selector', ".enable-#{data.single}")
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

    templateEvent = "click .disable-#{data.single}"
    if not DMUtils.find(Template._listRow._events, 'selector', ".disable-#{data.single}")
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

    templateEvent = "click .edit-#{data.single}"
    if not DMUtils.find(Template._listRow._events, 'selector', ".edit-#{data.single}")
      _listRowEvents[templateEvent] = (event,template) ->
        data = template.data
        single = data.context.single
        Session.set("edit-#{single}", data._id)
        element = $("##{data._id}")
        if element.hasClass('hidden')
          $('.form-row').addClass('hidden')
          element.removeClass('hidden')
        else
          element.addClass('hidden')
          Session.set("edit-#{single}", null)
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

    templateEvent = "click .close-form-#{data.single}"
    if not DMUtils.find(Template._listRow._events, 'selector', ".close-form-#{data.single}")
      _listRowEvents[templateEvent] = (event,template) ->
        data = template.data
        single = data.context.single
        element = $("##{data._id}")
        element.addClass('hidden')
        Session.set("edit-#{single}", null)
        return false

    # Add in or override user defined events.
    if data.list?.events?
      _.extend(data.list.events, listEvents)
      Template.lists.events(data.list.events)
    else
      Template.lists.events(listEvents)

    if data?.row?.events?
      _.extend(data.row.events, _listRowEvents)
      Template._listRow.events(data.row.events)
    else
      Template._listRow.events(_listRowEvents)

    # Build up an array of the items to be in the list
    # adding in the context data
    items = []
    # if data.parent_id
    #   data.subscribeCallback(data.parent_id)
    # else
    #   data.subscribeCallback()

    for item in data.items(data.parent_id)
      item.context = data
      items.push item

    if items.length > 0
      return items

Template.listNav.helpers
  nav: () ->
    # console.log 'listNav:nav', this
    data = this
    single = data.single
    plural = data.plural
    singleTitle = single.titleize()
    pluralTitle = plural.titleize()

    # Define some events that will be available even
    # if the user doesn't define them.  To override
    # these events simply define your own in the passed
    # data as nav.events.
    navEvents = {}
    templateEvent = "click .add-#{data.single}"

    if not DMUtils.find(Template.listNav._events, 'selector', ".add-#{data.single}")
      navEvents[templateEvent] = (event, template) ->
        context = template.data
        single = context.single
        klass = context.klass
        console.log "You have not defined a custom add handler for #{data.title}.  Using the default."
        if typeof context.newItemCallback isnt 'undefined'
          _id = context.newItemCallback(context.parent_id)
        else
          _id = klass.insert()
          console.log _id
   
        # Show the edit form after a 100ms delay after the item is inserted.
        showForm = () ->
          $("##{_id}").removeClass('hidden')

        setTimeout showForm, 100, _id

        return false  
    # ---------------------------------------------------------------------------------------

    templateEvent = "click .purge-disabled-#{data.plural}"
    if not DMUtils.find(Template.listNav._events, 'selector', ".purge-disabled-#{data.plural}")
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
    templateEvent = "keyup .#{data.single}-search-query"
    if not DMUtils.find(Template.listNav._events, 'selector', ".#{data.single}-search-query")
      navEvents[templateEvent] = (event, template) ->
        context = template.data
        single = context.single
        value = event.target.value
        $(".#{data.single}-search").removeClass("hide")
        if value?
          if value.has("=")
            key = value.split("=")[0]
            search_string = value.split("=")[1]
            search = {}
            search[key] = 
              $regex: ".*#{search_string}.*"
              $options: "i"
            Session.set("#{data.single}Find", search)
          else if value.has(" ")
            search_terms = value.split " "
            regex_array = 
              for term in search_terms
                 ".*#{term}.*"
            regex = regex_array.join "|"
            Session.set("#{data.single}Find", {name: {$regex: regex, $options: "i"}})
          else
            regex = ".*#{value}.*"
            Session.set("#{data.single}Find", {name: {$regex: regex, $options: "i"}})
        else
          Session.set("#{data.single}Find", {})
          $(".#{data.single}-search").addClass("hide")
          $(".#{data.single}-search-query").attr("value","")
        return false

    if data.nav?.events?
      _.extend(data.nav.events, navEvents)
      Template.listNav.events(data.nav.events)
    else
      Template.listNav.events(navEvents)

    # Setup the add and purge buttons if the user
    # didn't pass in any.
    if not data.addButton? and data.addButton isnt false
      data.addButton =
        title: "Add a #{singleTitle}"
        label: "Add a #{singleTitle}"
        click: "add-#{single}"
        style: "success"
        icon: "plus"

    if not data.purgeButton? and data.purgeButton isnt false
      data.purgeButton =
        title: "Purge Disabled #{pluralTitle}"
        label: "Purge Disabled #{pluralTitle}"
        click: "purge-disabled-#{plural}"
        style: "danger"
        icon: "remove"

    return data

Template._listRow.helpers
  disabled: () ->
    this.status

  selected: () ->
    context = this.context
    single = context.single
    if Session.get("selected-#{single}") is this._id
      return 'alert-info'


# Helper for the column headers.  data should have the field
# names in listFields.
UI.registerHelper 'listColumnHeaders', () ->
  listFields = this.listFields
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
  context = data.context
  
  data.row_css_class = "#{data._id}-row"
  data.listFields = context.listFields

  # console.log context.rowControls
  data.rowControls = {}
  for control in Object.keys(context.rowControls)
    array = []
    _control = context.rowControls[control]
    for item in Object.keys(_control)
      _item = _control[item]
      controlData = Object.reject(data, 'context')
      _item.data = controlData
      array.push _item
    data.rowControls[control] = array


  data.form = context.form
  data.inlineForm = context.inlineForm
  this.row = data
  this.data = data

  # console.log this
  return Template._listRow

UI.registerHelper 'listRowColumn', () ->
  this.value = this.data[this.field]
  return Template._listRowColumn
  
UI.registerHelper 'ListAddEditModal', () ->
  return Template._listAddEditModal

UI.registerHelper 'ListForm', () ->
  # console.log 'ListForm', this
  data = this.data
  fields = []

  if this.form.fields?
    providedFields = this.form.fields
  else
    providedFields = this.helpers.fields

  if not Array.isArray(providedFields)
    for key in Object.keys(providedFields)
      options = providedFields[key]
      options.name = key
      options.value = data[key]
      fields.add options
    this.fields = fields

  this.form_name = this.form.name

  return Template._listForm

Template._listForm.events
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

UI.registerHelper 'Count', (array) ->
  return array.length + 1