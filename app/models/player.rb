require 'digest/sha1'

class Player < ActiveRecord::Base
	has_many :match_participations
	has_and_belongs_to_many :matches

  has_many :laniheros
  has_many :heros, through: :laniheros

	def self.FindOrInsertPlayer id
		p = Player.where ({:accountid => id})
		if p == nil || p == []
			p = Player.where ({:accountid => 0})
		end
		return p.first
	end

  def ValidPassword pass
    Digest::SHA1.hexdigest(self.salt + pass) == self.password
  end

	def UpdatePlayerSum mp
		self.num_matches += 1
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

	def GetNewMatchIds
		steamapikey="supersecretlol"
		url = "https://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/V001/?account_id=" + self.accountid.to_s + "&key=" + steamapikey

		c = Curl::Easy.new url
		c.perform
		s = c.body_str
		o = JSON.parse s

		if o["result"]["matches"] == nil
			return []
		end

		ids = []

		o["result"]["matches"].each do |m|
			ids << m["match_id"]
		end

		return ids
	end

	scope :tapiplayers, -> { where("accountid != 0") }
end
