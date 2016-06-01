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


if !process.env.HUBOT_MOPIDY_URL
  return
  
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
      if not blacklist
        return
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

  robot.respond /blacklist song/i, (res) ->
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
    mopidy.playback.getCurrentTrack().then getCurrentTrack, console.error.bind(console)

  robot.respond /blacklist artist/i, (res) ->
    blacklist = robot.brain.get 'music-blacklist-artists'
    if not blacklist
      blacklist = []
    getCurrentTrack = (t) ->
        if t
          if t.artists.length > 1
            out = "Choose an artist to blacklist:\n"
            out += "  [{#index}] - #{artist.name}\n" for artist, index in t.artists
          else
            blacklist.push t.artists[0].name
            robot.brain.set 'music-blacklist-artists', blacklist
            res.send("Blacklisted artist #{t.artists[0].name}")
            mopidy.playback.next()
    mopidy.playback.getCurrentTrack().then getCurrentTrack, console.error.bind(console)

  robot.respond /blacklist artist (\d+)/i, (res) ->
    blacklist = robot.brain.get 'music-blacklist-artists'
    if not blacklist
      blacklist = []
    getCurrentTrack = (t) ->
        if t
          if res.match[1] < t.artists.length
            blacklist.push t.artists[res.match[1]].name
            robot.brain.set 'music-blacklist-artists', blacklist
            res.send("Blacklisted artist #{t.artists[0].name}")
            mopidy.playback.next()
    mopidy.playback.getCurrentTrack().then getCurrentTrack, console.error.bind(console)

  robot.respond /blacklist/i, (res) ->
    song_blacklist = robot.brain.get 'music-blacklist'
    if not song_blacklist
      song_blacklist = []
    artist_blacklist = robot.brain.get 'music-blacklist-artists'
    if not artist_blacklist
      artist_blacklist = []
    out = "Commands:\n"
    out += "  'blacklist' - Shows help and current blacklist\n"
    out += "  'blacklist song' - Blacklists the currently playing song\n"
    out += "  'blacklist artist' - List artists of current song to blacklist\n"
    out += "  'blacklist artist (id)' - Blacklists an artist from current song\n"
    out += "  'blacklist artist (name)' - Blacklists an artist\n"
    out += "  'blacklist remove (id)' - Remove song from blacklist using id\n"
    out += "  'blacklist remove artist (id)' - Remove artist from blacklist using id\n"
    out += "\n"
    out += "Current song list:\n"
    out += "  [#{index}] - #{title}\n" for title, index in song_blacklist
    out += "\n"
    out += "Current artist list:\n"
    out += "  [#{index}] - #{artist}\n" for artist, index in artist_blacklist
    res.send(out)

  robot.respond /blacklist remove (\d+)/i, (res) ->
    index = res.match[1]
    song_blacklist = robot.brain.get 'music-blacklist'
    if not song_blacklist
      song_blacklist = []
    if index < song_blacklist.length
      title = song_blacklist[index]
      song_blacklist.splice(title, 1)
      res.send("Removed " + title + " from blacklist")
    else
      res.send("Invalid id")

  robot.respond /blacklist remove artist (\d+)/i, (res) ->
    index = res.match[1]
    artist_blacklist = robot.brain.get 'music-blacklist-artists'
    if not artist_blacklist
      artist_blacklist = []
    if index < artist_blacklist.length
      artist = artist_blacklist[index]
      artist_blacklist.splice(artist, 1)
      res.send("Removed artist " + artist + " from blacklist")
    else
      res.send("Invalid id")

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
