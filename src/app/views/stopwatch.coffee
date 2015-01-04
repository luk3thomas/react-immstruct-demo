React       = require "react"
StopWatch   = require "../components/watch"

module.exports  = React.createClass
  displayName: "Stopwatch"
  render: ->
    (
      <div>
        <StopWatch stopwatch={@.props.app.cursor("stopwatch")}/>
      </div>
    )
