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
          message:   @_getMessageSchema(device)
          configure: @_getConfigureSchema(device)
          form:      @_getFormSchema(device)
      }

    _getConfigureSchema: (device) =>
      return {} if _.isEmpty device.optionsSchema
      return {
        default:
          type: 'object'
          properties:
            options: device.optionsSchema
      }

    _getFormSchema: (device) =>
      return {} if _.isEmpty device.messageFormSchema
      return {
        message:
          default:
            angular: device.messageFormSchema
      }

    _getMessageSchema: (device) =>
      return {} if _.isEmpty device.messageSchema
      return {
        default: _.assign({}, device.messageSchema, @_getFormMessageSchemaPortion(device))
      }

    _getFormMessageSchemaPortion: (device) =>
      return {} unless device.messageFormSchema
      return {
        'x-form-schema':
          angular: 'message.default.angular'
      }

  return OctobluDeviceSchemaTransmogrifier
