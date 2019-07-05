module MusicBot
  class Sender
    URI = ENV['WEBHOOK_URI']

    # expects Fetcher's instances
    def initialize(artist, articles)
      @artist = artist
      color = rand(Integer('0xFFFFFF')).to_s(16)
      @attachments = articles.map do |article|
        {
          fallback: "#{article.artist}の最新ニュース",
          color: "##{color}",
          author_name: article.author,
          thumb_url: article.thumbnail,
          title: article.title,
          title_link: article.url,
          text: article.description,
        }
      end
    end

    def send_to_slack
      build_params
      HTTParty.post(URI, @options)
    end

    def debug
      build_params
      p @options
    end

    private

    def build_params
      channel = ENV['RAILS_ENV'] == 'development' ? '#dev' : '#music-news'
      body = {
        attachments: @attachments,
        text: @artist,
        unfurl_links: true,
        channel: channel,
        username: 'newsbot',
        icon_emoji: ':headphones:'
      }
      @options = {
        body: body.to_json,
        headers: {
          'Content-Type' => 'application/json'
        }
      }
    end
  end
end
