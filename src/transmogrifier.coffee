# This weirdness is to support octoblu/bower-octoblu-device-schema-transmogrifier
module.exports = (_) =>
  class OctobluDeviceSchemaTransmogrifier
    constructor: (@device) ->
      throw new Error('Someone tried to transmogrify an undefined device! Stop doing that.') unless @device?

    transmogrify: =>
      device = _.cloneDeep @device
      return device if _.get(device, 'schemas.version') == '1.0.0'

      device.schemas = {version: '1.0.0'}
      @migrateMessageSchema device
      @migrateOptionsSchema device
      return device

    migrateMessageSchema: (device) =>
      { messageSchema } = device
      return unless messageSchema?
      delete device.messageSchema
      _.set device, 'schemas.message.default', messageSchema

    migrateOptionsSchema: (device) =>
      { optionsSchema } = device
      return unless optionsSchema?
      delete device.optionsSchema
      _.set device, 'schemas.configure.default.type', 'object'
      _.set device, 'schemas.configure.default.properties.options', optionsSchema

  return OctobluDeviceSchemaTransmogrifier
