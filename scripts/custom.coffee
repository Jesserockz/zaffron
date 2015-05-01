module.exports = (robot) ->

    coffeelines = [
      "Coffee is ready"
      "Coffee guys, get in the kitchen"
      "Brew complete"
      "Coffee going cold all alone"
    ]
    
    robot.respond /coffee/i, (res) ->
        res.send res.random coffeelines
        #run speech script

    robot.respond /say (.*)$/i, (res) ->
        text = res.match[1]
        @exec = require('child_process').exec
        command = "speech #{text}"

        @exec command, (error, stdout, stderr) ->
            res.send error
            res.send stdout
            res.send stderr
