{beforeEach, context, describe, it} = global
{expect} = require 'chai'

OctobluDeviceSchemaTransmogrifier = require '../'

describe 'migrating configure schemas', ->
  context 'with an unknown version', ->
    context 'a configureSchema with a single schema object', ->
      beforeEach ->
        @device =
          optionsSchema: yo: 'mo'

        @sut = new OctobluDeviceSchemaTransmogrifier @device
        @transmogrifiedDevice = @sut.transmogrify()

      it 'should create the correct configure schema object', ->
        expect(@transmogrifiedDevice.schemas.configure.default.properties.options).to.deep.equal yo: 'mo'
        expect(@transmogrifiedDevice.schemas.configure.default.type).to.deep.equal 'object'

      it 'should remove old configure schema', ->
        expect(@transmogrifiedDevice.optionsSchema).not.to.exist
