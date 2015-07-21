say = require("say")

module.exports = (robot) ->

  robot.respond /say (.*)$/i, (res) ->
    text = res.match[1]
    speakText "alex", text

  robot.respond /whisper (.*)$/i, (res) ->
    text = res.match[1]
    speakText "whisper", text

  robot.respond /speak (\w+) (.*)$/i, (res) ->
    voice = res.match[1]
    text = res.match[2]
    speakText voice, text

  robot.on "speakText",(data) ->
    speakText data.voice, data.text

  speakText = (voice,text) ->
    say.speak(voice, text)