coffeelines = [
  "Coffee is ready"
  "Coffee guys, get in the kitchen"
  "Brew complete"
  "Coffee going cold all alone"
]

mornings = [
  "Good morning @all"
  "Bom dia @all"
  "Ohayo Gozaimasu @all"
  "Bore da @all"
  "God morgon @all"
  "Guete Morge @all"
  "God morgen @all"
  "Kia ora @all"
  "Buenos dias @all"
  "Guten Morgen @all"
  "Bonjour @all"
]


TIMEZONE = "Pacific/Auckland"
STARTING_TIME = '0 20 17 * * 2-6' # M-F 5pm
ROOM = "55213_zaffron@conf.hipchat.com"

cronJob = require('cron').CronJob

module.exports = (robot) ->
  
  name = "(zaffron|zaff)"
  hi = "(hi|hello|welcome|yo|hey|howdy|good morning|greetings)"

  robot.respond /coffee/i, (res) ->
    line = res.random coffeelines
    res.send line
    speakText line, res

  robot.respond /say (.*)$/i, (res) ->
    text = res.match[1]
    speakText text, res

  # Hubot has an attitude
  robot.hear /tired|too hard|to hard|upset|bored/i, (msg) ->
    msg.send "Panzy"

  # Listen for hellos
  # ^(?=.*\b hi \b)(?=.*\b name \b).*$
  robot.hear ///^(?=.*\b #{hi} \b)(?=.*\b #{name} \b).*$///i, (msg) ->
    msg.reply "Hello"

  startofday = new cronJob STARTING_TIME,
    ->
      robot.messageRoom ROOM, mornings[ Math.floor(Math.random() * mornings.length)]
    null
    true
    TIMEZONE

  speakText = (text, res) ->
    @exec = require('child_process').exec
    command = "speech #{text}"
    @exec command, (error, stdout, stderr) ->
      #res.send error
      #res.send stdout
      res.send stderr