Meteor.subscribe('persons')
Meteor.subscribe('countries')

@personDefinition =
  klass: Persons
  single: 'person'
  plural: 'persons'
  _template: '_persons'
  title: "persons"
  open: null #"in"
  panelBodyCSS: 'tallPanel'
  formType: 'inline'

  form:
    fields:
      _id:
        required: true
        inputType: 'hidden'
        renderIfEmpty: false

      lastName:
        required: true
        inputType: 'text'
        renderIfEmpty: true
        size: 6
        # Add lookahead

      firstName:
        required: true
        inputType: 'text'
        renderIfEmpty: true
        size: 6

      hrule:
        inputType: 'hrule'
        size: 12
        cssClass: 'AnythingCool'
      month:
        required: true
        label: "Month - Array Backed"
        inputType: 'select'
        options: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul','Aug','Sep', 'Nov', 'Dec']
        size: 6
      countries:
        required: true
        label: "Countries - Collection Backed"
        inputType: 'select'
        options: Countries.find()
        display_attribute: 'name'
        size: 6

      blue:
        required: true
        inputType: 'checkbox'
        size: 12

      text:
        required: false
        inputType: 'xeditable'
        size: 12

    name: 'PersonAddEditForm'

  nav:
    purgeButton: false
    newItemCallback: (parent_id) ->
      values =
        createdBy: Meteor.user()
        createdAt: "#{moment().unix()}"
        fullName: 'Set Name'

      person_id = Persons.insert(values)
      if parent_id?
        data =
          person_id: person_id
          parent_id: parent_id

        # Insert the linking record
        PersonOfInterest.insert(data)

      return person_id


  list:
    inlineForm: true
    items: (parent_id) ->
      if parent_id?
        personsOfInterest = PersonOfInterest.find().fetch()
        data = []
        for person in personsOfInterest
          doc = Persons.findOne({_id: person.person_id})
          data.push(doc)
      else
        data = Persons.find({}).fetch()

      return data


    listFields:[
      {name: 'fullName'}
      {name: 'month'}
      {name: 'blue'}
      {name: 'countries',
      label: 'Country',
      transform: (_id) ->
        country = Countries.findOne({_id: _id})
        if country?
          return country.name
        else
          return ""
      }
    ]

    rowControls:
      enabled:
        edit:
          style: 'warning'
          icon: 'pencil'
          title: 'Edit'
          click: 'edit-person'

        disable:
          style: 'danger'
          icon: 'trash'
          title: 'Disable'
          click: 'disable-person'

      disabled:
        enable:
          style: 'success'
          icon: 'repeat'
          title: 'Enable'
          click: 'enable-person'

UI.registerHelper 'personsPanel', () ->
  if not this.parent_id?
    console.log this
    console.warn "parent_id is not defined for personPanel"

  return Template._persons


Template._persons.helpers
  list: () ->
    return Object.clone(personDefinition)

  nav: () ->
    data = Object.clone(personDefinition)

    singleTitle = data.single.titleize()
    pluralTitle = data.plural.titleize()
    data.nav.addButton =
      title: "Add a #{singleTitle}"
      label: "Add a #{singleTitle}"
      click: "add-#{data.single}"
      style: "success"
      icon: "plus"
      css: "navbar-btn"

    return data
