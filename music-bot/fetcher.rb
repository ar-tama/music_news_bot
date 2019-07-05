require 'httparty'

module MusicBot
  class Fetcher
    URI = 'https://api.cognitive.microsoft.com/bing/v7.0/news/search'

    attr_accessor :artist, :title, :description, :url, :thumbnail, :author

    def initialize(artist, article)
      @artist = artist
      @title = article['name']
      @description = article['description']
      @url = article['url']
      @author = article['provider'].first['name']

      image = ''
      if article.has_key?('image')
        image = article['image'].has_key?('contentUrl') ? article['image']['contentUrl'] : article['image']['thumbnail']['contentUrl']
      end
      @thumbnail = image
    end

    def self.crawl(artist)
      results = []
      get_news(artist).each do |res|
        results << self.new(artist, res)
      end
      results
    end

    def self.get_news(artist)
      options = {
        query: {
          q: artist,
          sortBy: 'date',
          mkt: 'ja-JP',
        },
        headers: {
          'Ocp-Apim-Subscription-Key' => ENV['AZURE_KEY'],
          'Content-Type' => 'application/json'
        }
      }
      res = HTTParty.get(URI, options)
      res["value"]
    end

    def self.debug(artist)
      res = JSON.parse('{"_type": "News", "readLink": "https://api.cognitive.microsoft.com/api/v7/news/search?q=MOCKY", "queryContext": {"originalQuery": "MOCKY", "adultIntent": false}, "totalEstimatedMatches": 5, "sort": [{"name": "最も一致する結果", "id": "relevance", "isSelected": true, "url": "https://api.cognitive.microsoft.com/api/v7/news/search?q=MOCKY"}, {"name": "最新", "id": "date", "isSelected": false, "url": "https://api.cognitive.microsoft.com/api/v7/news/search?q=MOCKY&sortby=date"}], "value": [{"name": "Mockyジャパン・ツアー直前DOMMUNE特番放送 ホストは花代とMoodman", "url": "https://www.cdjournal.com/main/news/mocky/82150", "image": {"thumbnail": {"contentUrl": "https://www.bing.com/th?id=ON.74211E0E3135A6918DDDA8B055C9CEAD&pid=News", "width": 700, "height": 466}}, "description": "4月10日（水）より放送が開始されるボンズ制作・渡辺信一郎総監督のTVアニメ「キャロル＆チューズデイ」での音楽担当が話題となっている鬼才・Mockyが、3月20日（水）の東京・恵比寿 LIQUIDROOM公演を皮切り、全11公演の大規模なジャパン・ツアーをスタート。", "about": [{"readLink": "https://api.cognitive.microsoft.com/api/v7/entities/31bf91b3-6a78-fa93-50ee-5a1965d77523", "name": "Mocky"}], "provider": [{"_type": "Organization", "name": "CDジャーナル"}], "datePublished": "2019-03-18T04:06:00.0000000Z", "category": "Entertainment"}, {"name": "王舟、3年ぶりオリジナルアルバム『Big fish』発売 東阪にてリリース ...", "url": "https://realsound.jp/2019/03/post-337117.html", "image": {"thumbnail": {"contentUrl": "https://www.bing.com/th?id=ON.B6B6EF09B6967B778E38AC0BDC55F169&pid=News", "width": 158, "height": 105}}, "description": "『PICTURE』以後は、MOCKYによるリミックスを収録した7インチシングル『Moebius』発売や、CM音楽提供などを行なってきた。『Big fish』には全11曲を ...", "about": [{"readLink": "https://api.cognitive.microsoft.com/api/v7/entities/6fa45fcc-45d7-5540-38df-8bed82426f66", "name": "Big Fish"}, {"readLink": "https://api.cognitive.microsoft.com/api/v7/entities/46a7babb-7378-0e3a-b43b-b34d7214af40", "name": "Real Sound: Kaze no Regret"}], "provider": [{"_type": "Organization", "name": "realsound.jp"}], "datePublished": "2019-03-22T10:16:00.0000000Z", "category": "Entertainment"}, {"name": "王舟、5月におよそ3年ぶりとなるオリジナル・アルバム『Big fish ...", "url": "https://okmusic.jp/news/328794", "description": "前作発表後、MOCKYによるリミックスを収録した7インチ・シングル『Moebius』、イタリア録音となったBIOMAN（neco眠る）との共作インスト・アルバム ...", "provider": [{"_type": "Organization", "name": "okmusic.jp"}], "datePublished": "2019-03-22T13:10:00.0000000Z", "category": "Entertainment"}, {"name": "「キャロル＆チューズデイ」制作の舞台裏ドキュメンタリー映像第2弾", "url": "http://www.ota-suke.jp/news/240175", "image": {"thumbnail": {"contentUrl": "https://www.bing.com/th?id=ON.5C3E40EEF0B08E74CA4585616A01F92F&pid=News", "width": 493, "height": 700}}, "description": "TVアニメ「キャロル&チューズデイ」とは 総監督は渡辺信一郎さん、監督は堀元宣さん、キャラクター原案は窪之内英策さん、キャラクターデザインは斎藤恒徳さん、音楽はMockyさん、音楽制作はフライングドッグ、アニメーション制作はボンズ。 人類が新た ...", "provider": [{"_type": "Organization", "name": "おたスケ"}], "datePublished": "2019-03-27T09:50:00.0000000Z", "category": "Entertainment"}, {"name": "「キャロル＆チューズデイ」人気ミューシャンを坂本真綾、安元洋貴", "url": "http://www.ota-suke.jp/news/239905", "image": {"thumbnail": {"contentUrl": "https://www.bing.com/th?id=ON.D8D5398DF209540E05D90E14A58974A9&pid=News", "width": 375, "height": 500}}, "description": "TVアニメ「キャロル&チューズデイ」とは 総監督は渡辺信一郎さん、監督は堀元宣さん、キャラクター原案は窪之内英策さん、キャラクターデザインは斎藤恒徳さん、音楽はMockyさん、音楽制作はフライングドッグ、アニメーション制作はボンズ。 人類が新た ...", "provider": [{"_type": "Organization", "name": "おたスケ"}], "datePublished": "2019-03-24T03:39:00.0000000Z", "category": "Entertainment"}]}')

      results = []
      res['value'].each do |article|
        results << self.new(artist, article)
      end
      results
    end
  end
end
