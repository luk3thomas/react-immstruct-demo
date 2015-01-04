React      = require("react/addons")
Lapper     = require "./lapper"
time       = require "../models/time"
immstruct  = require "immstruct"
cx         = React.addons.classSet

id = null
increment = 10

module.exports = React.createClass

  displayName: "StopWatch"

  propTypes:
    stopwatch: React.PropTypes.object.isRequired

  reset: (e)->
    e.stopPropagation()
    tick = 0
    @props.stopwatch.cursor("time").set "tick",    tick
    @props.stopwatch.cursor("time").set "display", time.parse(tick).display
    @props.stopwatch.update "laps", (laps) -> laps.clear()

  pause: ->
    @props.stopwatch.cursor("time").set "running", false
    clearInterval(id)
    id = null

  toggle: (e)->

    return @pause() if id?

    # run the clock
    id = setInterval(
      =>

        cursor = @props.stopwatch.cursor("time")
        tick   = cursor.get("tick") + increment

        cursor.set "tick",     tick
        cursor.set "running",  true
        cursor.set "display",  time.parse(tick).display

    , increment)

  componentWillUnmount: ->
    @pause() if id?

  render: ->
    cursor = @props.stopwatch.cursor("time")
    text   = if cursor.get("running") then "Stop" else "Start"
    [minute, second, hundreth] = time.parts(cursor.get("display"))

    total = @props.stopwatch.get("laps").reduce (m, d) ->
      d.duration + m
    , 0

    average  = total / @props.stopwatch.get("laps").count() or 1
    complete = (cursor.get("tick") - total) / average
    offset   = Math.max 1448 - 1448 * complete, 0
    rotation = complete * 360 or 0

    classes = cx
      "stopwatch-container": true
      running: cursor.get "running"
      "has-laps": @props.stopwatch.get("laps").count()

    # if there is time on the clock
    if cursor.get("tick") > 0
      laps  = <Lapper tick={cursor.get("tick")} running={cursor.get("running")} laps={@props.stopwatch.cursor(["laps"])}></Lapper>

    if cursor.get("tick") > 0 and not cursor.get("running")
      reset = <button className="reset-button button fa fa-refresh" onClick={@reset}></button>

    (
      <div onClick={@toggle} className={classes}>
        <svg className="stopwatch" width="500" height="300" viewBox="0 0 500 500">
          <circle className="circle" cx="250" cy="250" r="230"></circle>
          <g className="lap-timer">
            <circle id="lap-timer-outline" className="outline" cx="250" cy="250" r="230" style={strokeDashoffset: offset}></circle>
            <circle id="lap-timer-ball" className="ball" cx="250" cy="20" r="10" transform="rotate(#{rotation}, 250, 250)"></circle>
          </g>
          <g className="time">
            <text>
              <tspan y=0 x=0   className="minute">{minute}</tspan>
              <tspan y=0 x=80  className="second">{second}</tspan>
              <tspan y=0 x=210 className="hundreth">{hundreth}</tspan>
            </text>
          </g>
          <text x=205 y=400 className={"dialog dialog-#{text.toLowerCase()}"}>{text}</text>
        </svg>
        <div className="laps-container">
          {reset}
          {laps}
        </div>
      </div>
    )
