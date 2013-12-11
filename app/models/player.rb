class Player < ActiveRecord::Base
	has_many :match_participations
	has_and_belongs_to_many :matches

	def self.FindOrInsertPlayer id
		p = Player.where ({:accountid => id})
		if p == nil || p == []
			p = Player.where ({:accountid => 0})
		end
		return p.first
	end

	def UpdatePlayerSum mp
		self.num_matches += 1
		self.matches << mp.match
		self.sum_herodamage += mp.herodamage
		self.sum_towerdamage += mp.towerdamage
		self.sum_gold += mp.goldspent + mp.finishgold
		self.sum_gpm += mp.gpm
		self.sum_xpm += mp.xpm
		self.sum_kills += mp.kills
		self.sum_assists += mp.assists
		self.sum_deaths += mp.deaths
		self.sum_lasthits += mp.lasthits
		self.sum_denies += mp.denies
		self.sum_level += mp.level
		self.sum_tfc += mp.tfc
		save
	end
end
