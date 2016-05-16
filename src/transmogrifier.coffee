# This weirdness is to support octoblu/bower-octoblu-device-schema-transmogrifier
module.exports = (_) =>
  class OctobluDeviceSchemaTransmogrifier
    constructor: (@device) ->
      throw new Error('Someone tried to transmogrify an undefined device! Stop doing that.') unless @device?

    transmogrify: =>
      device = _.cloneDeep @device
      return device if _.get(device, 'schemas.version') == '1.0.0'

      messageSchema = device.messageSchema
      delete device.messageSchema

      device.schemas = {version: '1.0.0'}
      _.set device, 'schemas.message.default', messageSchema if messageSchema?
      return device

  return OctobluDeviceSchemaTransmogrifier
