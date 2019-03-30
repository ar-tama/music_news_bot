$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'sinatra/activerecord/rake'
require 'music-bot'

namespace :batch do
  task :run_crawler do
    MusicBot::Crawler.run
  end
end
