crypto = require "crypto"
co = require "co"
OSS = require "ali-oss"

module.exports = class Uploader

  constructor: (cfg) ->
    @region = cfg.region
    @accessKeyId = cfg.accessKeyId
    @accessKeySecret = cfg.accessKeySecret
    @bucket = cfg.bucket

  getKey: (buffer) ->
    fsHash = crypto.createHash('md5')
    fsHash.update(buffer)
    return fsHash.digest('hex')

  upload: (buffer, ext, callback) ->
    key = @getKey(buffer)
    filename = key
    filename += ".#{ext}" if typeof ext is 'string' and ext
    client =  new OSS({
      region: @region,
      accessKeyId: @accessKeyId,
      accessKeySecret: @accessKeySecret,
      bucket: @bucket
    });

    co(->
      ret = yield client.put("#{filename}", buffer)
      return ret
    ).then (ret) ->
      callback(null, {ret: ret, url:"#{ret.url}"})
      return
    .catch (err) ->
      callback(err)
      return

    return
