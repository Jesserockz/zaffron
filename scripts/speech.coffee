say = require("say")

module.exports = (robot) ->

  robot.respond /say (.*)$/i, (res) ->
    text = res.match[1]
    speakText "alex", text

  robot.respond /whisper (.*)$/i, (res) ->
    text = res.match[1]
    speakText "whisper", text

  robot.on "speakText",(data) ->
    speakText data.voice, data.text

  speakText = (voice,text) ->
    say.speak(data.voice,data.text)