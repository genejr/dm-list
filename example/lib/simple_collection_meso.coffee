@personFormDescription =
  name: 'PersonAddEditForm'
  method: 'addPerson'
  aggregates:
    fullName: ["join", ["firstName", "lastName"], " "]

  # removeFields: ['address1', 'address2', 'city', 'state', 'zip_code', 'main', 'fax']

  onSuccess: (formData, formHandle) ->
    console.log 'onSuccess', formData
    if Meteor.isClient
      $("##{formData._id}").addClass('hidden')

    # Mesosphere.Utils.successCallback(formData, formHandle);


  fields:
    _id:
      required: true

    lastName:
      required: true

    firstName:
      required: true

    blue:
      required: false
      default: false


Mesosphere personFormDescription
