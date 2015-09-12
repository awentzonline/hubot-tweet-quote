# Description:
#   Tweets quotes with the most votes.
#
# Author:
#   awentzonline

Twit = require "twit"

config =
  consumer_key: process.env.TWITTER_CONSUMER_KEY
  consumer_secret: process.env.TWITTER_CONSUMER_SECRET
  access_token: process.env.TWITTER_ACCESS_TOKEN
  access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET

unless config.consumer_key
  console.log "Please set the TWITTER_CONSUMER_KEY environment variable."
unless config.consumer_secret
  console.log "Please set the TWITTER_CONSUMER_SECRET environment variable."
unless config.access_token
  console.log "Please set the TWITTER_ACCESS_TOKEN environment variable."
unless config.access_token_secret
  console.log "Please set the TWITTER_ACCESS_TOKEN_SECRET environment variable."

T = new Twit config

quotes = {}

module.exports = (robot) ->
  robot.hear /^["'](.+)["']$/, (res) ->
    msg = res.match[1]
    if quotes[msg]
      T.post "statuses/update", {
        status: msg
      }, (err, data, response) =>
        res.send "https://twitter.com/#{data.user.screen_name}/status/#{data.id_str}"
        delete quotes[msg]
    else
      quotes[msg] = true
