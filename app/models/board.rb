class Board < ActiveRecord::Base
  belongs_to :user
  belongs_to :repo
  has_many :lists
end
