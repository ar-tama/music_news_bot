module MusicBot
  class Bot < SlackRubyBot::Bot
    command 'ping' do |client, data, match|
      client.say(text: 'pong', channel: data.channel)
    end

    command :list do |client, data, match|
      artists = MusicBot::Model::Artist.take(500) # tmp
      names = artists.map(&:name).join("\n")
      client.say(text: "Current subscribes...\n#{names}", channel: data.channel)
    end

    command :run do |client, data, match|
      MusicBot::Crawler.run
      client.say(text: 'Done!', channel: data.channel)
    end

    command 'subscribe', /.+/ do |client, data, match|
      _, artist = *match['command'].match(/unsubscribe\s(.+)/)
      command = :create_record
      if artist
        command = :delete_record
      else
        artist = match['expression']
      end

      if artist
        exception = self.send(command, artist)
        if exception
          client.say(text: exception, channel: data.channel)
        else
          client.say(text: "Ok, complete: #{artist}", channel: data.channel)
        end
      else
        client.say(text: 'ERROR: No artist name has given.', channel: data.channel)
      end
    end

    private

    def self.create_record(artist)
      begin
        MusicBot::Model::Artist.create(name: artist)
      rescue => exception
        return exception
      end
      nil
    end

    def self.delete_record(artist)
      begin
        record = MusicBot::Model::Artist.where(name: artist).first
        record.destroy if record
      rescue => exception
        return exception
      end
      nil
    end
  end
end
