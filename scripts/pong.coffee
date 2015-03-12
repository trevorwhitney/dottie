http = require('http')


module.exports = (robot) ->
  pongRoomAvailable = (callback) ->
    http.get 'http://pingpongping.cfapps.io/activity', (response) ->
      body = ''
      response.on 'data', (chunk)->
        body += chunk

      response.on 'end', ->
        pongResponse = JSON.parse(body)
        activePongs = 0

        for activity in pongResponse
          activePongs++ if activity.active

        callback(activePongs < 5)


  robot.respond /\s*can (i|we) pong\s*\?*\s*$/i, (msg) ->
    pongRoomAvailable (available) ->
      if available
        msg.reply 'Yes you can!'
      else
        msg.reply "Sorry, no pong for you."

  robot.hear /^\s*\d for pong\s*\?*\s*$/i, (msg) ->
    pongRoomAvailable (available) ->
      if available
        msg.send 'The pong room is open!'
      else
        msg.send 'Sorry, the pong room is occupied.'
