class Issue < ActiveRecord::Base
  belongs_to :repo
  has_one :card
end
