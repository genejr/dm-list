@Persons = new Meteor.Collection('persons');

Persons.allow
  insert: (userId, doc) ->
    true

  update: (userId, doc, fields, modifier) ->
      return userId == doc.user

  remove: (userId, doc) ->
    return userId && (doc.user == userId)

Persons.deny
  insert: (userId, doc) ->
    doc.createdAt = new Date().valueOf()
    return false;
  update: (userId, docs, fields, modifier) ->
    modifier.$set.updatedAt = new Date().valueOf()
    return false

Meteor.methods
  addPerson: (rawFormData) ->
    console.log rawFormData
    user = Meteor.users.findOne({_id: Meteor.userId()})
    validationObject = Mesosphere.PersonAddEditForm.validate(rawFormData)

    if not validationObject.errors
      values = validationObject.formData

      if Object.has(values, '_id')
        _id = values._id
        values = Object.reject(values, '_id')
        values.updatedBy = user
        values.updatedAt = "#{moment().unix()}"
        
        Persons.update _id, {$set: values},(error,result) ->
          saveCallback(error, 'person')
      else
        values.createdBy = user
        values.createdAt = "#{moment().unix()}"
        Classes.insert values, (error, result) ->
          saveCallback(error, 'person')

    else
      # saveCallback(validationObject.errors, 'persons')
      console.warn 'validationObject', validationObject.errors
