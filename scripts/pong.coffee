http = require('http')

module.exports = (robot) ->
  robot.respond /can I pong/i, (msg) ->
    canPong = false

    http.get 'http://pingpongping.cfapps.io/activity', (response) ->
      body = ''
      response.on 'data', (chunk)->
        body += chunk

      response.on 'end', ->
        pongResponse = JSON.parse(body)
        activePongs = 0

        for activity in pongResponse
          activePongs++ if activity.active

        canPong = true if activePongs < 5
        if canPong
          msg.reply 'Yes you can!'
        else
          msg.reply "No you can't"

