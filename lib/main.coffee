Uploader = require('./uploader');

{CompositeDisposable} = require 'atom'

module.exports =
  config:
    region:
      title: "region"
      type: 'string'
      description: "OSS Region"
      default: ""
    accessKeyId:
      title: "accessKeyId"
      type: 'string'
      description: "OSS accessKeyId"
      default: ""
    accessKeySecret:
      title: "accessKeySecret"
      type: 'string'
      description: "OSS accessKeySecret"
      default: ""
    bucket:
      title: "bucket"
      type: 'string'
      description: "OSS bucket"
      default: ""
    domain:
      title: "domain"
      type: 'string'
      description: "OSS domain"
      default: ""

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'oss-uploader:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()

  # `instance`:
  # API for markdown-assistant.
  # should return an uploader instance which has upload API
  #
  # usage:
  #   instance().upload(imagebuffer, '.png', (err, retData)->)
  #   * retData.url should be the online url
  instance: ->
    region = atom.config.get('oss-uploader.region')
    accessKeyId = atom.config.get('oss-uploader.accessKeyId')
    accessKeySecret = atom.config.get('oss-uploader.accessKeySecret')
    domain = atom.config.get('oss-uploader.domain')?.trim()
    bucket = atom.config.get('oss-uploader.bucket')

    if domain?.indexOf('http') < 0
      domain = "http://#{domain}"

    return unless region && accessKeyId && accessKeySecret && domain && bucket

    cfg = {
      region: region,
      accessKeyId: accessKeyId,
      accessKeySecret: accessKeySecret,
      domain: domain,
      bucket : bucket
    }
    return new Uploader(cfg)
