# Description
#   Control the mopidy music server
#
# Dependencies:
#   mopidy
#
# Configuration:
#  HUBOT_MOPIDY_WEBSOCKETURL (eg. ws://localhost:8282/mopidy/ws/)
#  (For now just change the webSocketUrl to your mopidy location)
#
#
# Commands:
#
#
#
# Notes:
#   None
#
# Author:
#   eriley



Mopidy = require("mopidy")

mopidy = new Mopidy(webSocketUrl: process.env.HUBOT_MOPIDY_URL+'/mopidy/ws/')
online = false
mopidy.on 'state:online', ->
  online = true
mopidy.on 'state:offline', ->
  online = false

getCurrentTrack = (track) ->
  if track
    
  else
    message.send("No track is playing")

module.exports = (robot) ->
  mopidy.on 'event:trackPlaybackStarted', (obj) ->
    tltrack = obj.tl_track
    if tltrack
      track = tltrack.track
      blacklist = robot.brain.get 'music-blacklist'
      getCurrentTrack = (t) ->
        if t
          if t.name in blacklist
            mopidy.playback.next()
            mopidy.playback.getCurrentTrack().then getCurrentTrack, console.error.bind(console)
      if track.name in blacklist
          mopidy.playback.next()
          mopidy.playback.getCurrentTrack().then getCurrentTrack, console.error.bind(console)
      
      # robot.messageRoom("55213_wump_music@conf.hipchat.com", "Currently playing: #{track.name} by #{track.artists[0].name} from #{track.album.name}")
      # robot.messageRoom("55213_wump_music@conf.hipchat.com", "/topic #{track.name} by #{track.artists[0].name}")
  #   else
  #     robot.messageRoom("55213_wump_music@conf.hipchat.com", "No music is playing")
  #     robot.messageRoom("55213_wump_music@conf.hipchat.com", "/topic No track is playing")

  robot.respond /blacklist/i, (res) ->
    blacklist = robot.brain.get 'music-blacklist'
    if not blacklist
      blacklist = []
    getCurrentTrack = (t) ->
        if t
          if t.name not in blacklist
            blacklist.push t.name
            robot.brain.set 'music-blacklist', blacklist
            res.send("Blacklisted #{t.name}")
            mopidy.playback.next()
          else
            res.send("Already blacklisted")


  robot.respond /set volume (\d+)/i, (message) ->
    newVolume = parseInt(message.match[1])
    if online
      mopidy.playback.setVolume(newVolume)
      message.send("Set volume to #{newVolume}")
    else
      message.send('Mopidy is offline')

  robot.respond /volume\?/i, (message) ->
    if online
      printCurrentVolume = (volume) ->
        if volume
          message.send("The Current volume is #{volume}")
        else
          message.send("Sorry, can't grab current volume")
    else
      message.send('Mopidy is offline')
    mopidy.playback.getVolume().then printCurrentVolume, console.error.bind(console)

  robot.respond /turn it down/i, (message) ->
    if online
      turnDownVolume = (volume) ->
        if volume
          newVolume = volume - 5
          message.reply("Sorry, I am turning down to #{newVolume}")
          mopidy.playback.setVolume(newVolume)
        else
          message.send("Sorry, can't change the volume at this time")
    else
      message.send("Mopidy is offline")
    mopidy.playback.getVolume().then turnDownVolume, console.error.bind(console)

  robot.respond /turn it up/i, (message) ->
    if online
      turnUpVolume = (volume) ->
        if volume
          newVolume = volume + 5
          message.reply("You got it, turning up to #{newVolume}")
          mopidy.playback.setVolume(newVolume)
        else
          message.send("Sorry, can't change the volume at this time")
    else
      message.send("Mopidy is offline")
    mopidy.playback.getVolume().then turnUpVolume, console.error.bind(console)

  robot.respond /quiet|i have a headache/i, (message) ->
    if online
      mopidy.playback.setVolume(10)
      message.reply("sorry")
    else
      message.send('Mopidy is offline')

  robot.hear /what'?(s | is )?playing/i, (message) ->
    if online
      printCurrentTrack = (track) ->
        if track
          artists = ""
          artists += "#{artist.name}, " for artist in track.artists
          message.send("Currently playing: #{track.name} by #{artists}from #{track.album.name}")
        else
          message.send("No track is playing")
    else
      message.send('Mopidy is offline')
    mopidy.playback.getCurrentTrack().then printCurrentTrack, console.error.bind(console)

  robot.respond /next (?=track)?|(?=skip)+ (?=track)?/i, (message) ->
    if online
      mopidy.playback.next()
      printCurrentTrack = (track) ->
        if track
          artists = ""
          artists += "#{artist.name}, " for artist in track.artists
          message.send("Now playing: #{track.name} by #{artists}from #{track.album.name}")
        else
          message.send("No track is playing")
    else
      message.send('Mopidy is offline')
    mopidy.playback.getCurrentTrack().then printCurrentTrack, console.error.bind(console)

  robot.respond /mute/i, (message) ->
    if online
      mopidy.playback.setMute(true)
      message.send('Playback muted')
    else
      message.send('Mopidy is offline')

  robot.respond /unmute/i, (message) ->
    if online
      mopidy.playback.setMute(false)
      message.send('Playback unmuted')
    else
      message.send('Mopidy is offline')

  robot.respond /pause music|turn it off/i, (message) ->
    if online
      mopidy.playback.pause()
      message.send('Music paused')
    else
      message.send('Mopidy is offline')

  robot.respond /resume music/i, (message) ->
    if online
      mopidy.playback.resume()
      message.send('Music resumed')
    else
      message.send('Mopidy is offline')

  robot.respond /shuffle music/i, (message) ->
    if online
      mopidy.tracklist.setRandom(true)
      message.send('Now shuffling')
    else
      message.send('Mopidy is offline')

  robot.respond /stop shuffle/i, (message) ->
    if online
      mopidy.tracklist.setRandom(false)
      message.send('Shuffling has been stopped')
    else
      message.send('Mopidy is offline')
