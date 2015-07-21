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

say = require("say")

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
    robot.emit "speakText", {
      voice : "good news",
      text  : line
    }

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
    #  speakText "hysterical", "wroffle", res
    #else
    #  speakText "hysterical", lol, res

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

  speakText = (voice, text, res) ->
    say.speak(voice,text);
