Google Analtyics Reporting [![Build Status](https://drone.io/github.com/Turistforeningen/node-ga-report/status.png)](https://drone.io/github.com/Turistforeningen/node-ga-report/latest)
==========================

NodeJS wrapper for Google Analytics Core Reporting API

# API

## Instanciate

```javascript
Report = require('ga-report');

var report = new Report('user@gmail.com', 'mypassword');
var report.once('ready', function() {
  // ready to report
});
```

## Get Accounts

```javascript
report.getAccounts(function(err, accounts) {
  console.error(err);
  for (var i = 0; i < accounts.length; i++) {
    console.log(accounts[i]);
  }
});
```

## Get Webproperties

```javascript
report.getWebproperties(accountId, function(err, webproperties) {
  console.error(err);
  for (var i = 0; i < webproperties.length; i++) {
    console.oog(webproperties[i]);
  }
});
```

## Get Webproperties

```javascript
report.getWebproperties(accountId, webpropertyId, function(err, profile) {
  console.error(err);
  for (var i = 0; i < profiles.length; i++) {
    console.oog(profiles[i]);
  }
});
```

## Get Report

```javascript
var options = {
  'ids': 'ga:123456-UA',
  'start-date': '2013-10-01',
  'end-date': '2013-10-31',
  'metrics': 'ga:visits,ga:bounces'
};
report.get(options, functon(err, data) {
  if (err) console.error(err);
  console.dir(data);
)};
```

