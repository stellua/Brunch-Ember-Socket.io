config                  = require('../../../config').config
passport                = require 'passport'
TwitterStrategy         = require('passport-twitter').Strategy
LocalStrategy           = require('passport-local').Strategy
BasicStrategy           = require('passport-http').BasicStrategy
ClientPasswordStrategy  = require('passport-oauth2-client-password').Strategy
BearerStrategy          = require('passport-http-bearer').Strategy
models                  = require '../../models'

# --- serializing and deserializing user
# passport.serializeUser (user, done) ->
#   done null, user.id

# passport.deserializeUser (id, done) ->
#   db.users.find id, (err, user) ->
#     done null, user

# --- Local Strategy ---
# passport.use new LocalStrategy (username, password, done) ->
#   console.log 'local Strategy'
#   db.users.findByUsername username, (err, user) ->
#     return done err if err
#     return done null, false if !user?
#     return done null, false if user.password isnt password
#     done null, user

# --- BasicStrategy & ClientPasswordStrategy ---
passport.use new BasicStrategy (username, password, done) ->
  models.client.findById username, (err, client) ->
    return done err           if err
    return done null, false   if not client
    return done null, false   if client.secret is not password
    done null, client

passport.use new ClientPasswordStrategy (clientId, clientSecret, done) ->
  models.client.findById clientId, (err, client) ->
    return done err           if err
    return done null, false   if not client
    return done null, false   if client.secret is not clientSecret
    done null, client

# --- BearerStrategy ---
passport.use new BearerStrategy (accessToken, done) ->
  models.accessToken.findOne { oauth_token: accessToken }, (err, token) ->
    return done err           if err
    return done null, false   if not token

    models.user.findById token.user_id, (err, user) ->
      return done err         if err
      return done null, false if not user
      # need to implement restrict scopes before production
      done null, user, { scope: '*' }

# Twitter Strategy
passport.use new TwitterStrategy {
  consumerKey:    config.auth.Twitter.CONSUMER_KEY
  consumerSecret: config.auth.Twitter.CONSUMER_SECRET
  callbackURL:    config.auth.Twitter.callbackURL
}, 
(token, tokenSecret, profile, done) ->
  process.nextTick ->
    done null, profile


