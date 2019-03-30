module MusicBot
  module Model
    class Artist < ActiveRecord::Base
      scope :recently_not_crawled, -> {
        where(crawled_at: nil).or(where(arel_table[:crawled_at].lt(Time.now - 86400 * 3)))
      }

      def self.bulk_update_crawled_at(records)
        self.transaction do
          records.each do |record|
            record.crawled_at = Time.now
            record.save!
          end
        end
      end
    end
  end
end
