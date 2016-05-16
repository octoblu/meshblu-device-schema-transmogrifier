OctobluDeviceSchemaTransmogrifier = require '../'

{beforeEach, context, describe, it} = global
{expect} = require 'chai'

describe 'migrating message schemas', ->
  context 'with an unknown version', ->
    context 'a messageSchema with a single schema object', ->
      beforeEach ->
        @device =
          messageSchema: sup: 'g'

        @sut = new OctobluDeviceSchemaTransmogrifier @device
        @transmogrifiedDevice = @sut.transmogrify()

      it 'should create the correct message schema array', ->
        expect(@transmogrifiedDevice.schemas.message.default).to.deep.equal sup: 'g'

      it 'should remove old message schema', ->
        expect(@transmogrifiedDevice.messageSchema).not.to.exist
