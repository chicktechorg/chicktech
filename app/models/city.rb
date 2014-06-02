class City < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  has_many :events, :dependent => :destroy
  has_many :users
end
