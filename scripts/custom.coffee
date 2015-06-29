coffeelines = [
  "Coffee is ready"
  "Coffee guys, get in the kitchen"
  "Brew complete"
  "Stop, Coffee time"
  "Fresh cup of joe everybody"
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

lulz = [
  "lol",
  "lmao",
  "rofl",
  "lulz",
  "ha ha"
]

module.exports = (robot) ->

  robot.hear /^(?=.*sorry)(?=.*zaffron).+/i, (msg) ->
    if robot.brain.get('ignore_mention') == msg.message.user.mention_name
      robot.brain.set 'ignore', false
      robot.brain.set 'ignore_mention', ''
      msg.send 'I forgive you @'+msg.message.user.mention_name

  robot.hear /(.*)$/i, (msg) ->
    if robot.brain.get('ignore') && robot.brain.get('ignore_mention') == msg.message.user.mention_name
      msg.finish()
  
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
    msg.send "you may command me by mentioning me first"

  # Listen for hellos
  # ^(?=.*\b hi \b)(?=.*\b name \b).*$
  robot.hear ///^(?=.*\b #{hi} \b)(?=.*\b #{name} \b).*$///i, (msg) ->
    msg.reply "Hello"

  #robot.hear /lol|lmao|lulz|rofl/, (res) ->
  #  lol = res.random lulz
  #  res.send lol
    #if lol=="rofl"
    #  speakText "wroffle", res
    #else
    #  speakText lol, res

  robot.hear /^(?=.*shutup|shut up|fuck off|go away)(?=.*zaffron).+/i, (res) ->
    robot.brain.set 'ignore', true
    robot.brain.set 'ignore_mention', res.message.user.mention_name
    res.send "fine"

  robot.hear /who am i/i, (msg) ->
    user = msg.message.user
    for key, value of user
      msg.send key + ": " + value
    #res.send res.message.user.reply_to
    #console.log res.message

  speakText = (text, res) ->
    @exec = require('child_process').exec
    command = "speech #{text}"
    @exec command, (error, stdout, stderr) ->
      #res.send error
      #res.send stdout
      res.send stderr
