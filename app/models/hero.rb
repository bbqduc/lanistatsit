class Hero < ActiveRecord::Base
	has_many :match_participations
end
