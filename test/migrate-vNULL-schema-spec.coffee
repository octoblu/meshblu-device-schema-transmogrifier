_ = require 'lodash'
OctobluDeviceSchemaTransmogrifier = require '../'

describe 'a device with data', ->
  beforeEach ->
    @device =
      other: true
    @sut = new OctobluDeviceSchemaTransmogrifier @device
    @transmogrifiedDevice = @sut.transmogrify()

  it 'should preserve existing data', ->
    expect(@transmogrifiedDevice.other).to.be.true

  it 'should set the version to 1.0.0', ->
    expect(@transmogrifiedDevice.schemas.version).to.equal '1.0.0'

describe "when trying to transmogrify a device that doesn't exist", ->
  beforeEach ->
    try
      new OctobluDeviceSchemaTransmogrifier()
    catch e
      @error = e

  it "should throw an exception telling us how bad the core dispatcher is for giving us no data.", ->
    expect(@error).to.exist
    expect(@error.message).to.equal "Someone tried to transmogrify an undefined device! Stop doing that."

describe 'migrating a v1 schema', ->
  beforeEach ->
    @device =
      optionsSchema: {whatever: true}
      schemas:
        version: '1.0.0'

    @sut = new OctobluDeviceSchemaTransmogrifier @device
    @transmogrifiedDevice = @sut.transmogrify()

  it 'should do nothing', ->
    expect(@transmogrifiedDevice).to.deep.equal @device
