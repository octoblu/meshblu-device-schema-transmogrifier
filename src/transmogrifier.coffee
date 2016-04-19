_ = require 'lodash'
class MeshbluDeviceTransmogrifier
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
    @device.schemas.messages ?= []
    @device.schemas.messages.push @device.messageSchema

    delete @device.messageSchema

module.exports = MeshbluDeviceTransmogrifier
