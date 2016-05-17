# This weirdness is to support octoblu/bower-octoblu-device-schema-transmogrifier
module.exports = (_) =>
  class OctobluDeviceSchemaTransmogrifier
    constructor: (@device) ->
      throw new Error('Someone tried to transmogrify an undefined device! Stop doing that.') unless @device?

    transmogrify: =>
      return _.cloneDeep @device if _.get(@device, 'schemas.version') == '1.0.0'

      device = @migratedSchemas @device
      return _.omit device, 'messageSchema', 'messageFormSchema', 'optionsSchema'

    migratedSchemas: (device) =>
      device = _.cloneDeep device

      _.assign device, {
        schemas:
          version: '1.0.0'
          message:
            default: _.assign(device.messageSchema, @_getFormMessageSchemaPortion(device))
          configure:
            default:
              type: 'object'
              properties:
                options: device.optionsSchema
          form:
            message:
              default:
                angular: device.messageFormSchema
      }

    _getFormMessageSchemaPortion: (device) =>
      return {} unless device.messageFormSchema
      return {
        formSchema:
          angular: 'message.default.angular'
      }

  return OctobluDeviceSchemaTransmogrifier
