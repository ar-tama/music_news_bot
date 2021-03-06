module MusicBot
  class Bot < SlackRubyBot::Bot
    command 'ping' do |client, data, match|
      client.say(text: 'pong', channel: data.channel)
    end

    command :help do |client, data, match|
      message = <<MESSAGE
      newsbotの使い方
      @newsbot subscribe アーティスト名 ... 登録できるぞ！
      @newsbot unsubscribe アーティスト名 ... 登録を解除できるぞ！
      @newsbot list ... 現在の登録状況が見られるぞ！
      @newsbot run ... 登録されているアーティストのニュースを取ってくるぞ！（ニュースは放っておいても3日おきに配信されるぞ！）
      @newsbot run アーティスト名 ... 登録はせずにニュースを取ってくるぞ！
MESSAGE
      client.say(text: message, channel: data.channel)
    end

    command :list do |client, data, match|
      artists = MusicBot::Model::Artist.take(500) # tmp
      names = artists.map(&:name).join("\n")
      client.say(text: "Current subscribes...\n#{names}", channel: data.channel)
    end

    # TODO: Sanitize
    command :run, /run\s(.+)$/ do |client, data, match|
      artist = match['expression']
      if artist
        MusicBot::Crawler.run_with_artist_name(artist)
        client.say(text: 'Done!', channel: data.channel)
      else
        MusicBot::Crawler.run_all
        client.say(text: 'Done!', channel: data.channel)
      end
    end

    command 'subscribe', /^subscribe\s(.+)$/ do |client, data, match|
      artist = match['expression']
      if artist
        exception = self.create_record(artist)
        if exception
          client.say(text: exception, channel: data.channel)
        else
          client.say(text: "Ok, complete: #{artist}", channel: data.channel)
        end
      else
        client.say(text: 'ERROR: No artist name has given.', channel: data.channel)
      end
    end

    command 'unsubscribe', /^unsubscribe\s(.+)$/ do |client, data, match|
      artist = match['expression']
      if artist
        exception = self.delete_record(artist)
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
