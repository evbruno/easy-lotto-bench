class Lottery < ActiveRecord::Base
  has_many :games, dependent: :destroy
  has_many :prizes, through: :games, source: :prizes, dependent: :destroy
  has_many :draws, through: :games, source: :draws, dependent: :destroy
end
