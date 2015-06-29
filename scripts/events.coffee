# Description:
#   Training hubot script
#   Search events in http://techevents.nz for location
#
# Notes:
# Commands:
#   hubot events <[all | wellington | auckland]> - List all current upcoming events in locations

module.exports = (robot) ->

  parser = require 'parse-rss'
  _ = require ('underscore');

  displayNumber = 5
  robot.respond /events(.*)/i,  (res) ->

    searchMessage = 'Searching for events for'
    errorMessage = 'Sorry, i am having trouble connecting to connect events sever.'
    eventBaseUrl = "http://techevents.nz/rss"
    locations = ['all', 'wellington', 'auckland']
    eventUrl = ""

    location = res.match[1].trim()
    console.log location
    if location? && location != ""
      if  _.contains locations, location.toLowerCase()
        eventUrl= "#{eventBaseUrl}/#{location}"
        searchMessage = "#{searchMessage} #{location} ..."
      else
        invalidMessage = "Sorry, cannot map the location your search for.\n"
        invalidMessage += "Plase try /events <[all | wellington | auckland]>"
        res.send invalidMessage
        return
    else
      eventUrl= "#{eventBaseUrl}/all"
      searchMessage = "Search all events for you ..."

    res.send searchMessage

    #Search & Parsing
    parser eventUrl , (err, rss) ->
      if err
        res.send errorMessage
      else
        renderEvents(res, rss.slice(0, displayNumber))

  renderEvents = (res, rss) ->
    _.each rss, (event) ->
      eventTitle = event.title
      eventDescription = event.description
      eventLink =  event.link
      eventMessage = "#{eventTitle} \n #{eventLink}"
      res.send eventMessage