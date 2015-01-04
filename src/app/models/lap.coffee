time   = require "./time"

module.exports = (latest, previous = 0, list)->
  lap =
    tick: latest
    duration: latest - previous
    display: time.parse(latest - previous).display
    diff: null

  if list.length
    lap.diff = time.diff(lap.duration - list.slice(-1)[0].duration)

  lap
