React      = require "react"
lap        = require "../models/lap"
time       = require "../models/time"
Lap        = require "./_lap"
immstruct  = require "immstruct"


module.exports = React.createClass
  displayName: "Lapper"

  stopPropagation: (e) ->
    e.stopPropagation()

  lap: ->
    @props.laps.update (d) =>
      previous = @props.laps.reverse().first()?.tick or 0
      d.push(lap(@props.tick, previous, d.toJSON()))

  propTypes:
    tick:    React.PropTypes.number.isRequired
    laps:    React.PropTypes.object.isRequired
    running: React.PropTypes.bool.isRequired

  render: ->

    laps = @props.laps.map (lap, i) ->
      <Lap key={"id#{lap.display}#{i}"} lap={lap} />
    .toJSON()

    if @props.running
      button = <button onClick={@lap} className="lap-button button fa fa-rotate-right" disabled={not @props.running}></button>

    if @props.laps.count()
      average = (@props.laps.reduce (m, d) ->
        d.duration + m
      , 0) / @props.laps.count() or 1

      average = <p>Average lap time is <span>{time.parse(average).display}</span></p>

    (
      <div onClick={@stopPropagation} className="lapper">
        {button}
        <ol className="lapper">
          {laps}
        </ol>
        {average}
      </div>
    )
