"use strict"

Report = require '../src/ga-report.coffee'
assert = require 'assert'

report = accountId = webpropertyId = profileId = null

before (done) ->
  report = new Report
    username: process.env.GA_API_USERNAME
    password: process.env.GA_API_PASSWORD

  report.once 'ready', done

describe 'new Report()', ->
  it 'should instanciate successfully', ->
    assert.equal typeof report.token, 'string'
    assert.equal report.tokenType, 'GoogleLogin'

describe '#getAccounts()', ->
  it 'should return an array with accounts', (done) ->
    report.getAccounts (err, accounts) ->
      assert.ifError err
      assert accounts instanceof Array

      accountId = accounts[0].id

      done()

describe '#getWebproperties()', ->
  it 'should return an array with webproperties', (done) ->
    report.getWebproperties accountId, (err, webproperties) ->
      assert.ifError err
      assert webproperties instanceof Array

      webpropertyId = webproperties[0].id

      done()

describe '#getProfiles()', ->
  it 'should return an array with profiles', (done) ->
    report.getProfiles accountId, webpropertyId, (err, profiles) ->
      assert.ifError err
      assert profiles instanceof Array

      profileId = profiles[0].id

      done()

describe '#get()', ->
  it 'should return an array with results', (done) ->
    options =
      ids: 'ga:' + profileId
      'start-date': '2013-10-01'
      'end-date': '2013-10-31'
      metrics: 'ga:visits,ga:bounces'

    report.get options, (err, data) ->
      assert.ifError err
      assert data.rows instanceof Array

      done()

