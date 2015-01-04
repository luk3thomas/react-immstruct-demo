time    = require "app/models/time"

now =
results = null

describe "models/Time", ->

  beforeEach ->
    now     = new Date(1420172551627)
    results = time.parse(+now)

  describe "#parse", ->

    it "returns the correct minute", ->
      expect(results.minute).toBe "22"

    it "returns the correct second", ->
      expect(results.second).toBe "31"

    it "adds a leading 0 to the second", ->
      now.setSeconds(1)
      expect(time.parse(+now).second).toBe "01"

    it "returns the correct millisecond", ->
      expect(results.hundreth).toBe "62"

    it "adds a leading 0 to the millisecond", ->
      now.setMilliseconds(0)
      expect(time.parse(+now).hundreth).toBe "00"

    it "pads millisecond by three", ->
      now.setMilliseconds(10)
      expect(time.parse(+now).hundreth).toBe "01"

      now.setMilliseconds(100)
      expect(time.parse(+now).hundreth).toBe "10"


  describe "#to_date", ->

    it "parses stopwatch display to date", ->
      {minute, second, hundreth, display} = time.parse("1:21.46")
      expect(minute)      .toBe "1"
      expect(second)      .toBe "21"
      expect(hundreth)    .toBe "46"
      expect(display)     .toBe "1:21.46"


  describe "#parts", ->

    it "parses stopwatch display to parts", ->
      [minute, second, hundreth] = time.parts("1:21.46")
      expect(minute)      .toBe "1"
      expect(second)      .toBe "21"
      expect(hundreth)    .toBe "46"

  describe "#diff", ->

    it "shows the + difference between times", ->
      {sign, minute, second, hundreth} = time.diff(1234)
      expect(sign)         .toBe "+"
      expect(minute)       .toBe "0"
      expect(second)       .toBe "01"
      expect(hundreth)     .toBe "23"

    it "shows the - difference between times", ->
      {sign, minute, second, hundreth} = time.diff(-1234)
      expect(sign)         .toBe "-"
      expect(minute)       .toBe "0"
      expect(second)       .toBe "01"
      expect(hundreth)     .toBe "23"
