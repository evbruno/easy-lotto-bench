class Game < ActiveRecord::Base
  belongs_to :lottery
  has_many :prizes, dependent: :destroy
  has_many :draws, dependent: :destroy
end
