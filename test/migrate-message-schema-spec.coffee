{beforeEach, context, describe, it} = global
{expect} = require 'chai'
_ = require 'lodash'

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

  context 'with no schema at all', ->
    beforeEach ->
      @device = {}
      @sut = new OctobluDeviceSchemaTransmogrifier @device
      @transmogrifiedDevice = @sut.transmogrify()

    it 'should set an empty schema', ->
      expect(@transmogrifiedDevice.schemas).to.deep.equal {
        version: '1.0.0'
        message: {}
        configure: {}
        form: {}
      }

  describe 'migrating a v1.0.0 schema', ->
    beforeEach ->
      @device =
        schemas:
          version: '1.0.0'

      @sut = new OctobluDeviceSchemaTransmogrifier _.cloneDeep(@device)
      @transmogrifiedDevice = @sut.transmogrify()

    it 'should do nothing', ->
      expect(@transmogrifiedDevice).to.deep.equal {
        schemas:
          version: '1.0.0'
      }

  describe 'migrating a v2.0.0 schema', ->
    beforeEach ->
      @device =
        schemas:
          version: '2.0.0'

      @sut = new OctobluDeviceSchemaTransmogrifier _.cloneDeep(@device)
      @transmogrifiedDevice = @sut.transmogrify()

    it 'should do nothing', ->
      expect(@transmogrifiedDevice).to.deep.equal {
        schemas:
          version: '2.0.0'
      }
