module MusicBot
  class Crawler
    def self.run
      artists = MusicBot::Model::Artist.recently_not_crawled.limit(30)
      self.run_with_artists(artists)
    end

    def self.run_all
      artists = MusicBot::Model::Artist.limit(500) #tmp
      self.run_with_artists(artists)
    end

    private

    def self.run_with_artists(artists)
      artists.each do |artist|
        name = artist.name
        articles = MusicBot::Fetcher.crawl(name)
        if articles.size > 0
          MusicBot::Sender.new(name, articles).send_to_slack
        end
      end
      MusicBot::Model::Artist.bulk_update_crawled_at(artists)
    end
  end
end
