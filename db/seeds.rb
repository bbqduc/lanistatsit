# Thi/ file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'json'

s = IO.read "db/seed_data.json"
matches = JSON.parse s

def InsertTapiiris
	Player.create({:accountid => 20684381,
				:name => "bduc"})
	Player.create({:accountid => 34891907,
				:name => "Zmo"})
	Player.create({:accountid => 9196866,
				:name => "motonen"})
	Player.create({:accountid => 25590587,
				:name => "torttuPmies"})
	Player.create({:accountid => 82009679,
				:name => "XermoS"})
	Player.create({:accountid => 0,
				:name => "Non-Tapiiri"})
end

def InsertHeroes
	s = IO.read Rails.root.join('db', 'heroids.json')
	heroes = JSON.parse s
	heroes["result"]["heroes"].each do |h|
		Hero.create ({:heroid => h["id"],
				:name => h["localized_name"],
				:image_name => h["name"].slice(14, h["name"].size) + "_sb.png"
		})
	end
end

def InsertLaniHeroes
  Lanihero.create({
    :hero_id => Hero.first.id,
    :player_id => Player.first.id,
    :comment => "Lanihero from seeds.rb"
  })
end

InsertHeroes()
InsertTapiiris()
matches.each { |m| Match.InsertMatch(m, Logger.new("/dev/null")) }
InsertLaniHeroes()
