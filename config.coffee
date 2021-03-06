fs      = require 'fs'
sysPath = require 'path'

exports.config  =
  paths:
    public: 'public'

  coffeelint:
    pattern: /^app\/.*\.coffee$/
    options:
      indentation:
        value: 2
        level: "error"

  files:
    javascripts:
      joinTo:
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^vendor/
        'test/javascripts/test.js': /^test[\\/](?!vendor)/
        'test/javascripts/test-vendor.js': /^test[\\/](?=vendor)/
      order:
        # Files in `vendor` directories are compiled before other files
        # even if they aren't specified in order.
        before: [
          'vendor/scripts/console-helper.js'
          'vendor/scripts/jquery-1.9.0.min.js'
          'vendor/scripts/jquery.cookie-latest.js'
          'vendor/scripts/handlebars-latest.js'
          'vendor/scripts/ember-latest.js'
          'vendor/scripts/ember-data-latest.js'
          'vendor/scripts/ember-auth.min.js'
          'vendor/scripts/bootstrap.js'
        ]

    stylesheets:
      joinTo:
        'stylesheets/app.css': /^(app|vendor)/
        'test/stylesheets/test.css': /^test/
      order:
        before: ['vendor/styles/normalize.css']
        after: ['vendor/styles/helpers.css']

    templates:
      precompile: true
      root:             'app/templates'
      joinTo:           'javascripts/app.js' : /^app/
      defaultExtension: 'emblem'
      paths:
        # If you don't specify jquery and ember there,
        # raw (non-Emberized) Handlebars templates will be compiled.
        jquery:     'vendor/scripts/jquery-1.9.0.min.js'
        ember:      'vendor/scripts/ember-latest.js'
        handlebars: 'vendor/scripts/handlebars-latest.js'
        emblem:     'vendor/scripts/emblem.js'

  conventions:
    ignored: (path) ->
      startsWith = (string, substring) ->
          string.indexOf(substring, 0) is 0
      sep = sysPath.sep
      if path.indexOf("app#{sep}templates#{sep}") is 0
          false
      else
          startsWith sysPath.basename(path), '_'

  # server config are only used during 'brunch watch --server'
  server:
    path:       'server/server.coffee'
    port:       3333
    run:        yes
    base:       '/'

  client:
    id:         1
    secret:     'secret'
    clientId:   'linguis'

  socket:
    default:
      transports: [
        'websocket'
        'htmlfile'
        'jsonp-polling'
        'xhr-polling' ]
      duration:   5
    heroku:
      transports: [ 'xhr-polling' ]
      duration:   10

  auth:
    Twitter:
      CONSUMER_KEY:     'SfGuSgebLa3731RjyFRQRA'
      CONSUMER_SECRET:  'WI20TnZCBaq7actB1OCHAnug0gX0jTveZEKJbmgw'
      callbackURL:      'http://young-brook-4706.herokuapp.com/auth/twitter/callback'

  db:
    host:               'mongodb://localhost/linguis'
    poolSize:           3
