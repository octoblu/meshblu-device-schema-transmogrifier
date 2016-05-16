_ = require 'lodash'
OctobluDeviceSchemaTransmogrifier = require '../'

describe 'migrating message schemas', ->
  context 'with an unknown version', ->
    context 'a messageSchema with a single schema object', ->
      beforeEach ->
        @device =
          messageSchema: sup: 'g'

        @sut = new OctobluDeviceSchemaTransmogrifier @device
        @transmogrifiedDevice = @sut.transmogrify()

      it 'should create the correct message schema array', ->
        expect(@transmogrifiedDevice.schemas.message).to.deep.contain sup: 'g'

      it 'should remove old message schema', ->
        expect(@transmogrifiedDevice.messageSchema).not.to.exist

    context 'a messageSchema with an array', ->
      beforeEach ->
        @messageSchema = [
            {sup: 'g'}
            {mechanical: 'animals'}
          ]
        @device = messageSchema: @messageSchema


        @sut = new OctobluDeviceSchemaTransmogrifier @device
        @transmogrifiedDevice = @sut.transmogrify()

      it 'should create the correct message schema array', ->
        expect(@transmogrifiedDevice.schemas.message).to.deep.equal @messageSchema

      it 'should remove old message schema', ->
        expect(@transmogrifiedDevice.messageSchema).not.to.exist
