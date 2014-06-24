@saveCallback =  (error, collection) ->
  form_name = "##{collection.titleize()}AddEditForm"

  if error
    throw error
  if Meteor.isClient
    Meteor.Notices.throw('Your record was successfully saved.', 'success')
