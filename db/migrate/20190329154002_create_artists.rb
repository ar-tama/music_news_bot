class CreateArtists < ActiveRecord::Migration[5.2]
  def change
    create_table "artists", id: :integer, unsigned: true do |t|
      t.string "name", null: false
      t.datetime "created_at", null: false
      t.datetime "crawled_at"
      t.index ['name'], name: 'on_name'
    end
  end
end
