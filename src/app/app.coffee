React      = require "react"
Router     = require "react-router"
{Route, DefaultRoute, NotFoundRoute}   = Router


Main        = require "./views/main.coffee"
StopWatch   = require "./views/stopwatch.coffee"
Timer       = require "./views/timer.coffee"
NotFound    = require "./views/404.coffee"

immstruct   = require "immstruct"
data        = immstruct "app",
  stopwatch:
    time:
      tick: 0
      running: false
      display: "0:00.00"
    laps: []

window.i = immstruct

routes = (
  <Route handler={Main} path="/">
    <DefaultRoute handler={StopWatch} />
    <Route name="timer" handler={Timer} />
    <Route name="stopwatch" handler={StopWatch} />
    <NotFoundRoute handler={NotFound}/>
  </Route>
)

Router.run routes, (Handler)->

  render = (n, o)->
    React.render(<Handler app={data.cursor()} />, document.getElementById("app"))

  data.on "swap", render
  render()
