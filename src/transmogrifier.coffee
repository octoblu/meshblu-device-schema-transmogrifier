# This weirdness is to support octoblu/bower-octoblu-device-schema-transmogrifier
module.exports = (_) =>
  class OctobluDeviceSchemaTransmogrifier
    constructor: (oldDevice) ->
      throw new Error('Someone tried to transmogrify an undefined device! Stop doing that.') unless oldDevice?
      @device = _.clone oldDevice
      @device.schemas = _.cloneDeep oldDevice.schemas

    transmogrify: =>
      return @device if _.get(@device, 'schemas.version') == '1.0.0'
      _.set @device, 'schemas.version', '1.0.0'

      @_migrateMessageSchema()

      return @device

    _migrateMessageSchema: =>
      messageSchema = @device.messageSchema
      delete @device.messageSchema
      @device.schemas.messages ?= []
      return @device.schemas.messages = messageSchema if _.isArray messageSchema
      @device.schemas.messages.push messageSchema

  return OctobluDeviceSchemaTransmogrifier
