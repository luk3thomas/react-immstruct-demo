React      = require "react/addons"
cx         = React.addons.classSet
time       = require "../models/time"

module.exports = React.createClass
  displayName: "Lap"

  propTypes:
    lap: React.PropTypes.object.isRequired

  render: ->
    {display, diff} = @props.lap
    parts = time.parts(display)
    signs = cx
      sign: true
      plus:  diff?.sign is "+"
      minus: diff?.sign is "-"

    if diff
      difference =
        <span className="lap lap-diff">
          <span className={signs}>     {diff.sign}</span>
          <span className="minutes">   {diff.minute}</span>
          <span className="separator-minutes">:</span>
          <span className="seconds">   {diff.second}</span>
          <span className="separator-seconds">.</span>
          <span className="hundreths"> {diff.hundreth}</span>
        </span>

    <li className="lap">
      <span className="lap-time">
        <span className="minutes">   {parts[0]}</span>
        <span className="separator-minutes">:</span>
        <span className="seconds">   {parts[1]}</span>
        <span className="separator-seconds">.</span>
        <span className="hundreths"> {parts[2]}</span>
      </span>

      {difference}
    </li>
