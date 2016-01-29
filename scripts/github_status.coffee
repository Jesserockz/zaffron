module.exports = (robot) ->

  previous_timestamp = '2016-01-28T23:29:26Z'

  room = '55213_test_room@conf.hipchat.com'
  setInterval ->
    do everyMinute
  , 30000
  everyMinute = ->
    req = robot.http("https://status.github.com/api/last-message.json")
    req.get() (err, res, body) ->
      json = JSON.parse(body)
      console.log(json.body)
      if json.created_on != previous_timestamp
        if json.status == 'major'
          robot.messageRoom room, '@all GITHUB CRASHED!!! (omg) - ' + json.body
        else if json.status == 'minor'
          robot.messageRoom room, '@all GitHub had an accident (lol) - ' + json.body
        else
          robot.messageRoom room, '@all GitHub - ' + json.body
        previous_timestamp = json.created_on

  robot.respond /github/i, (msg) ->
    req = robot.http("https://status.github.com/api/last-message.json")
    req.get() (err, res, body) ->
      json = JSON.parse(body)
      if json.status == 'major'
        msg.reply 'GITHUB CRASHED!!! (omg) - ' + json.body
      else if json.status == 'minor'
        msg.reply 'GitHub had an accident (lol) - ' + json.body
      else
        msg.reply 'GitHub - ' + json.body