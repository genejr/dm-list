@DMUtils = {}

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
  if user?.profile?.name?
    return user.profile.name
  else
    return '-----'