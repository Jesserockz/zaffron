coffeelines = [
  "Coffee is ready"
  "Coffee guys, get in the kitchen"
  "Brew complete"
  "Stop, Coffee time"
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

  robot.respond /introduce yourself/i, (msg) ->
    msg.send "hi @all"
    msg.send "My name is zaffron"
    msg.send "you may command me by mentionsing me first"

  # Listen for hellos
  # ^(?=.*\b hi \b)(?=.*\b name \b).*$
  robot.hear ///^(?=.*\b #{hi} \b)(?=.*\b #{name} \b).*$///i, (msg) ->
    msg.reply "Hello"

  speakText = (text, res) ->
    @exec = require('child_process').exec
    command = "speech #{text}"
    @exec command, (error, stdout, stderr) ->
      #res.send error
      #res.send stdout
      res.send stderr
