require 'dotenv'
Dotenv.load

require 'slack-ruby-bot'
require 'httparty'
require 'json'
require 'sinatra/activerecord'

require 'music-bot/bot'
require 'music-bot/web'
require 'music-bot/fetcher'
require 'music-bot/sender'
require 'music-bot/crawler'
require 'music-bot/models/artist'
