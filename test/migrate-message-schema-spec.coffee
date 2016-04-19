_ = require 'lodash'
MeshbluDeviceTransmogrifier = require '../'

describe 'migrating message schemas', ->
  context 'with an unknown version', ->
    beforeEach ->
      @device =
        messageSchema: sup: 'g'

      @sut = new MeshbluDeviceTransmogrifier @device
      @transmogrifiedDevice = @sut.transmogrify()

    it 'should create the correct message schema array', ->
      expect(@transmogrifiedDevice.schemas.messages).to.deep.contain sup: 'g'

    it 'should remove old message schema', ->
      expect(@transmogrifiedDevice.messageSchema).not.to.exist
