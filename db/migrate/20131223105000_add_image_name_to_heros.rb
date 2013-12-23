require 'json'
class AddImageNameToHeros < ActiveRecord::Migration
  def change
    add_column :heros, :image_name, :string

	s = IO.read Rails.root.join('db', 'heroids.json')
	heroes = JSON.parse s
	heroes["result"]["heroes"].each do |h|
		hero = Hero.find_by heroid: h["id"] 
		hero.image_name = h["name"].slice(14, h["name"].size) + "_sb.png"
		hero.save
	end
  end
end
