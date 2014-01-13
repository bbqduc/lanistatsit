class Lanihero < ActiveRecord::Base
  belongs_to :player
  belongs_to :hero
end
