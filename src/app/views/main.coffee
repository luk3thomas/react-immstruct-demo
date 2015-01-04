React           = require "react"
{RouteHandler, Link}  = require "react-router"


Main = React.createClass
  displayName: "Main"
  render: ->

    items = "stopwatch:fa-circle-o-notch timer:fa-clock-o"
      .split(" ")
      .map (d, i) ->
        [route, icon] = d.split ":"

        <li className="nav-item" key={i}>
          <Link to={route} className="nav-link"><i className="fa #{icon}"></i></Link>
        </li>

    <div>
      <header>
      </header>
      <RouteHandler app={@.props.app} />
    </div>

module.exports = Main
