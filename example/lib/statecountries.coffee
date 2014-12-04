@Countries = new Meteor.Collection("countries")
@States = new Meteor.Collection("states")

if Meteor.isServer
  Meteor.startup () ->
    # Countries collection initialization.
    countries_count = Countries.find().count()
    if countries_count is 0
      console.log "Adding countries"
      countries_csv = Assets.getText('country.csv')
      parse = Meteor.npmRequire('csv').parse
      Future  = Meteor.npmRequire('fibers/future')
      future = new Future()
      parse countries_csv, {comment: '#'}, (err, data)->
        future.return(data)

      results = future.wait()
      for country in results
        iso = country[0]
        name = country[1]
        selected = false

        # Setup the default country.  Do this so there is no
        # flashing in the interface when the country list is
        # populated then changed when there is no user selected
        # country.
        if name is 'United States'
          selected = true

        Countries.insert {iso: iso, name: name, selected: selected}


    # States collection initialization.
    states_count = States.find().count()
    if states_count is 0
      console.log "Adding states"
      states_csv = Assets.getText('states.csv')
      parse = Meteor.npmRequire('csv').parse
      Future  = Meteor.npmRequire('fibers/future')
      future = new Future()
      parse states_csv, {comment: '#'}, (err, data)->
        future.return(data)
      # csv()
      # .from.string(states_csv, {comment: '#'})
      # .to.array (data) ->
      #   return future.return(data)

      results = future.wait()
      for state in results
        iso = state[1]
        name = state[0]

        States.insert {iso: iso, name: name}

  Meteor.publish 'countries', () ->
    return Countries.find({})

  Meteor.publish 'states', () ->
    return States.find({})

if Meteor.isClient
  Meteor.subscribe 'countries'
  Meteor.subscribe 'states'