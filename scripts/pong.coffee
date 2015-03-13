http = require('http')

module.exports = (robot) ->
  pongRoomAvailable = (callback) ->
    http.get 'http://pingpongping.cfapps.io/activity', (response) ->
      body = ''

      if response.statusCode != 200
        callback(2)

      response.on 'data', (chunk)->
        body += chunk

      response.on 'end', ->
        pongResponse = JSON.parse(body)
        activePongs = 0

        for activity in pongResponse
          activePongs++ if activity.active

        returnCode = 0

        callback(if activePongs < 5 then 0 else 1)


  robot.respond /\s*can (i|we) pong\s*\?*\s*$/i, (msg) ->
    pongRoomAvailable (availabilityCode) ->
      switch availabilityCode
        when 0 then msg.reply 'Yes you can!'
        when 1 then msg.reply 'Sorry, no pong for you.'
        when 2 then msg.reply 'Sorry, I have no data. Is the sensor pi down?'

  robot.hear /^\s*\d for pong\s*\?*\s*$/i, (msg) ->
    pongRoomAvailable (availabilityCode) ->
      switch availabilityCode
        when 0 then msg.send 'The pong room is open!'
        when 1 then msg.send 'Sorry, the pong room is occupied.'
        when 2 then msg.send 'Sorry, I have no data. Is the sensor pi down?'
