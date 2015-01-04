lap    = require "app/models/lap"

result = null

describe "models/Lap", ->
  beforeEach ->
    result = lap(1234 * 2, 1234, [duration: 2000])

  it "stores duration of the lap", ->
    expect(result.duration).toBe 1234

  it "stores the tick difference between laps", ->
    expect(result.tick).toBe 1234 * 2

  it "displays the difference between laps", ->
    expect(result.display).toBe "0:01.23"

  xit "displays the difference between averages", ->
    difference = 1234 * 2 - (2000 + 1234 * 2) / 2
    expect(result.diff).toBe difference
