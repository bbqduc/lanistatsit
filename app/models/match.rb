class Match < ActiveRecord::Base
	has_many :match_participations
	has_and_belongs_to_many :players;
end
