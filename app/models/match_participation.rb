class MatchParticipation < ActiveRecord::Base
	belongs_to :player
	belongs_to :hero
	belongs_to :match
end
