class Repo < ActiveRecord::Base
  belongs_to :user
  has_one :board
  has_many :issues
end
