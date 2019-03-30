require 'sinatra/base'

module MusicBot
  class Web < Sinatra::Base
    get '/' do
      'Music is good for you.'
    end
  end
end
