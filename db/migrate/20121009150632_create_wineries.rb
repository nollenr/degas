class CreateWineries < ActiveRecord::Migration
  def change
    create_table :wineries, primary_key_trigger: true do |t|
      t.string :name, null: false
      t.string :country, null: false
      t.string :location1, null: false
      t.string :location2, null: false
      t.string :location3, null: true
      t.string :facebook_url, null: true
      t.string :twitter_url, null: true
      t.string :winery_url, null: true

      t.timestamps
    end
  end
end
