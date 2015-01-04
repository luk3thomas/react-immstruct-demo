Time = ->

Time::to_date = (time)->
  type = typeof time

  if ["number", "string"].indexOf(type) is -1
    throw new TypeError "Time isn't number or string"

  if type is "string"
    [minute, second, hundreth] =
      time.replace(/:/, ".").split(".").map (d) -> +d

    time = (minute * 60 + second + hundreth / 100) * 1000

  new Date(time)

Time::parse = (time)->

  d = @to_date(time)

  results =
    minute: d.getMinutes().toString()
    second: d.getSeconds().toString().replace /^([0-9])$/, "0$1"
    hundreth: d.getMilliseconds().toString()
      .replace /^([0-9]{2})$/, "0$1"
      .slice(0,2)
      .replace /^([0-9])$/, "0$1"

  results.display = "#{results.minute}:#{results.second}.#{results.hundreth}"

  results

Time::diff = (time)->
  diff = @parse(Math.abs(time))
  diff.sign = if time < 0 then "-" else "+"
  diff

Time::parts = (display)->
    display.replace(/:/, ".").split(".")

module.exports = new Time

