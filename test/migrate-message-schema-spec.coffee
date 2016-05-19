{beforeEach, context, describe, it} = global
{expect} = require 'chai'

OctobluDeviceSchemaTransmogrifier = require '../'

describe 'migrating message schemas', ->
  context 'with an unknown version', ->
    context 'a messageSchema with a single schema object', ->
      beforeEach ->
        @device =
          messageSchema:
            type: 'object'
            properties:
              sup:
                type: 'string'
          messageFormSchema: [{
            key: 'sup'
          }]

        @sut = new OctobluDeviceSchemaTransmogrifier @device
        @transmogrifiedDevice = @sut.transmogrify()

      it 'should create the correct message schema array', ->
        expect(@transmogrifiedDevice.schemas.message).to.deep.equal
          default:
            type: 'object'
            'x-form-schema':
              angular:
                'message.default.angular'
            properties:
              sup:
                type: 'string'

      it 'should create the correct form message schema array', ->
        expect(@transmogrifiedDevice.schemas.form.message).to.deep.equal
          default:
            angular:
              [{
                key: 'sup'
              }]

      it 'should remove old message schema', ->
        expect(@transmogrifiedDevice.messageSchema).not.to.exist
