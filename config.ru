$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'music-bot'

Thread.abort_on_exception = true

Thread.new do
  begin
    MusicBot::Bot.run
  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end

run MusicBot::Web
