http = require('http')


module.exports = (robot) ->
  reportPongStatus = (msg, successMsg, failMsg) ->
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
          msg.reply successMsg
        else
          msg.reply failMsg

  robot.hear /^\s*can (i|we) pong\s*\?*\s*$/i, (msg) ->
   reportPongStatus(msg, 'Yes you can!', "No you can't")

  robot.hear /^\s*\d for pong\s*\?*\s*$/i, (msg) ->
    reportPongStatus(msg, 'The pong room is open!', 'Sorry, the pong room is occupied.')
