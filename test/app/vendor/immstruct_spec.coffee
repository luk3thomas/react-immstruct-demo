# Need to know how this works, that's all ...

immstruct      = require "immstruct"

describe "vendor/immstruct", ->

  it "cursor allows access to object", ->
    cursor = immstruct({foo: 1, bar: 2}).cursor()
    expect(cursor.get("foo")).toBe 1

  it "nested cursor allows access to object", ->
    cursor = immstruct
      foos:
        foo: 1
        bar: 2
    .cursor()
    foos = cursor.get("foos")
    expect(foos.get("foo")).toBe 1

  it "nested cursor updates parent object", (done) ->
    expectation = ->
      expect(data.cursor(["foos", "foo"]).deref()).toBe "bar"
      done()

    data = immstruct
      foos:
        foo: 1
        bar: 2
    data.on "swap", expectation

    foos = data.cursor("foos")
    foos.update "foo", ->
      return "bar"


    expect(foos.get("foo")).toBe 1
