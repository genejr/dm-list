@DMUtils = {}

# Extending Array's prototype
# unless Array::filter
#   Array::filter = (callback) ->
#     element for element in this when callback(element)


DMUtils.toArray = (obj) ->
  if not obj
    return []
  else if DMUtils.typeOf(obj) isnt '[object Array]'
    return [obj]
  else
    return obj
  
DMUtils.typeOf = (obj) ->
  if obj && obj.typeName
    return obj.typeName
  else
    return Object.prototype.toString.call(obj)

DMUtils.assert = (condition, msg) ->
  if not condition
    throw new Error(msg)

DMUtils.find = (data, field, needle) ->
  if typeof data is 'undefined'
    return false

  find = (data.filter (i) -> i[field] is needle)[0]
  if find?
    return true
  else
    return false

DMUtils.transformDate = (date) ->
  if not date
    return '-----'
  return moment.unix(date).format("DD MMM YYYY HH:mm")

DMUtils.transformUser = (user) ->
  return user.profile.name


@selectOptions = (options) ->
  # @item            = The item that we are passed to interrogate for information
  # @attribute       = The attribute to look into for data for the checked
  #                    items.
  # @sessionSelector = What session variable to store values in so that
  #                    they persist over a HCR
  DMUtils.assert(DMUtils.typeOf(options) is '[object Object]', 'Please pass in an options object.')
  DMUtils.assert(DMUtils.typeOf(options.attribute) is '[object String]', 'options.attribute missing')
  DMUtils.assert(DMUtils.typeOf(options.sessionSelector) is '[object String]', 'options.sessionSelector missing')
  DMUtils.assert(DMUtils.typeOf(options.item) is '[object Object]', 'options.item should be a collection document')

  attribute = options.attribute
  sessionSelector = options.sessionSelector
  item = options.item

  search = {}
  sort = {}
  idAttribute = '_id'
  labelAttribute = 'name'
  items = null
  
  textCheckedCallback = (item, userSelectedCollection, attributeArray) ->
  if attributeArray.length > 0
    if (item in userSelectedCollection) or (item in attributeArray)
      return 'checked'

  objectCheckedCallback = (item, userSelectedCollection, attributeArray) ->
  if attributeArray.length > 0
    if (item._id in userSelectedCollection) or (item._id in attributeArray)
      return 'checked'

  if DMUtils.typeOf(options.search) is '[object Object]'
    search = options.search

  if DMUtils.typeOf(options.sort) is '[object Object]'
    sort = options.sort

  if DMUtils.typeOf(options.idAttribute) is '[object String]'
    idAttribute = options.idAttribute

  if DMUtils.typeOf(options.labelAttribute) is '[object String]'
    labelAttribute = options.labelAttribute

  if DMUtils.typeOf(options.items) is '[object Array]'
    items = options.items

  if DMUtils.typeOf(options.labelCallback) is '[object Function]'
    labelCallback = options.labelCallback

  if DMUtils.typeOf(options.checkedCallback) is '[object Function]'
    checkedCallback = options.checkedCallback

  if DMUtils.typeOf(options.klass) is '[object Object]'
    DMUtils.assert(items == null, "You can't set items and klass.  Pick one please.")
    klass = options.klass
    items = klass.find(search, sort).fetch()

  DMUtils.assert(items != null, 'Items need to be passed as an option or Klass needs to be set.')

  attributeArray = DMUtils.toArray(prop(item,attribute))
  
  if DMUtils.typeOf(options.setSessionVariables) is '[object Array]'
    setSessionVariables = options.setSessionVariables
    for sessionVar in setSessionVariables
      if typeof Session.get(sessionVar) is 'undefined'
        Session.set(sessionVar, attributeArray)

  if typeof Session.get(sessionSelector) is 'undefined'
    Session.set(sessionSelector, attributeArray)

  userSelectedCollection = Session.get(sessionSelector) or []
  
  options = []
  for _item in items
    checked = ''
    if DMUtils.typeOf(_item) is '[object String]'
      if DMUtils.typeOf(checkedCallback) is '[object Function]'
        checked = checkedCallback(item, _item)
      else
        checked = textCheckedCallback(_item, userSelectedCollection, attributeArray)

      if DMUtils.typeOf(labelCallback) is '[object Function]'
        label = labelCallback(_item)
      else
        label = _item

      _id = _item
    else
      if DMUtils.typeOf(checkedCallback) is '[object Function]'
        checked = checkedCallback(item, _item)
      else
        checked = objectCheckedCallback(_item, userSelectedCollection, attributeArray)

      if DMUtils.typeOf(labelCallback) is '[object Function]'
        label = labelCallback(_item)
      else
        label = _item[labelAttribute]

      _id = _item[idAttribute]

    obj = 
      option_label: label
      _id: _id
      checked: checked
    options.add obj
  return options