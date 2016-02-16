class User < ActiveRecord::Base
  has_many :repos
  has_many :boards
end
