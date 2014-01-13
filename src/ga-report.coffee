"use strict"

request = require 'request'
events = require 'events'
util = require 'util'

#
# Report Class
#
# @param config - configuration parameters
#
Report = (config) ->
  events.EventEmitter.call @

  if config?.username and config?.password
    @getToken config.username, config.password, (err, token) =>
      return @emit 'error', err if err
      @tokenType = 'GoogleLogin'
      @token = token
      @emit 'ready'
  else
    @emit 'error', new Error('Not Supported')

  @

util.inherits Report, events.EventEmitter
module.exports = Report

#
# Get auth token from user and password
#
# @param username - google apps email or gmail email
# @param password - plain text password
# @param cb - callback method (err, token)
#
Report.prototype.getToken = (username, password, cb) ->
  url = 'https://www.google.com/accounts/ClientLogin'
  data =
    Email: username,
    Passwd: password,
    accountType: "HOSTED_OR_GOOGLE",
    source: "curl-accountFeed-v2",
    service: "analytics"

  request.post url, form: data, (err, res, data) ->
    m = data.match /(Auth=[^\s]*)\s/
    return cb null, m[1] if m
    return cb new Error('Authentication Failed')

#
# Get Accounts List
#
# @param cb - callback method (err, token)
#
Report.prototype.getAccounts = (cb) ->
  options =
    url: 'https://www.googleapis.com/analytics/v3/management/accounts'
    json: true
    headers:
      Authorization: @tokenType + " " + @token
      "GData-Version": 2

  request options, (err, res, data) ->
    return cb null, data.items if data?.items
    return cb new Error('Command Failed')

#
# Get Webproperties for Account
#
# @param accountId - account ID
# @param cb - callback method (err, token)
#
Report.prototype.getWebproperties = (accountId, cb) ->
  options =
    url: 'https://www.googleapis.com/analytics/v3/management/accounts/' + accountId + '/webproperties'
    json: true
    headers:
      Authorization: @tokenType + " " + @token
      "GData-Version": 2

  request options, (err, res, data) ->
    return cb null, data.items if data?.items
    return cb new Error('Command Failed')

#
# Get Profiles for Webproperty
#
# @param accountId - account ID
# @param webpropertyId - webproperty ID
# @param cb - callback method (err, token)
#
Report.prototype.getProfiles = (accountId, webpropertyId, cb) ->
  options =
    url: 'https://www.googleapis.com/analytics/v3/management/accounts/' + accountId + '/webproperties/' + webpropertyId + '/profiles'
    json: true
    headers:
      Authorization: @tokenType + " " + @token
      "GData-Version": 2

  request options, (err, res, data) ->
    return cb null, data.items if data?.items
    return cb new Error('Command Failed')

#
# Get Accounts List
#
# @paraam options - query options
# @param cb - callback method (err, token)
#
# @TODO(starefossen) validate required options
#
Report.prototype.get = (options, cb) ->
  args = []
  args.push key + '=' + encodeURIComponent(val) for key, val of options

  options =
    url: 'https://www.googleapis.com/analytics/v3/data/ga?' + args.join '&'
    json: true
    headers:
      Authorization: @tokenType + " " + @token
      "GData-Version": 2

  request options, (err, res, data) ->
    return cb null, data if data
    return cb new Error('Command Failed')

