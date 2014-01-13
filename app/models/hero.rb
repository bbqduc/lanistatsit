class Hero < ActiveRecord::Base
	has_many :match_participations
  has_many :laniheros
  has_many :players, through: :laniheros
end
